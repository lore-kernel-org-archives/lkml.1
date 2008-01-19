Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbYASQNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbYASQNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761230AbYASQNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:13:00 -0500
Received: from pat.uio.no ([129.240.10.15]:60040 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682AbYASQM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:12:59 -0500
Subject: Re: Where's the create() pointer?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Justin Banks <justinb@bakbone.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080119150718.GA14765@bleen.domain.actdsltmp>
References: <20080119150718.GA14765@bleen.domain.actdsltmp>
Content-Type: text/plain
Date: Sat, 19 Jan 2008 11:12:55 -0500
Message-Id: <1200759175.8028.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: BD52A3994FAE06706321A4F4C472529DCBF28B53
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 93 total 6344004 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 08:07 -0700, Justin Banks wrote:
> It's probably been this way for a long time, and I'm just noticing, but
> I can't seem to find the create() (among others) pointer for NFS filesystems.
> 
> Specifically, If I look at sb->s_root->d_inode->i_op there's no create
> there. How do I find it? I'm guessing that the ability to share mount
> structures between multiple NFS mounts resulted in some kind of fake
> superblock, but I just can't figure out where to find the functions.

Why would you want to do this in the first place?

Anyhow, to answer the question: sb->s_root is not guaranteed to be a
real file on NFS. The real mountpoints are usually in the anonymous
dentry list.

Trond

