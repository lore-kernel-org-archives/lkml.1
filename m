Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbXLMBIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbXLMBIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 20:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXLMBHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 20:07:55 -0500
Received: from pat.uio.no ([129.240.10.15]:59735 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXLMBHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 20:07:55 -0500
Subject: Re: BUG fs/dcache.c:595 in 2.4.24rc3-git3 during NFS umount
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <20071212234248.GD31699@bingen.suse.de>
References: <200712031623.58223.ak@suse.de> <200712081422.30815.ak@suse.de>
	 <1197243901.11792.1.camel@heimdal.trondhjem.org>
	 <20071210185720.GA32466@bingen.suse.de>
	 <1197428085.28126.3.camel@heimdal.trondhjem.org>
	 <20071212234248.GD31699@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 20:02:30 -0500
Message-Id: <1197507750.8554.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.3, required=5.0, autolearn=disabled, AWL=-0.341)
X-UiO-Scanned: 384250BC2EFBA371F1284D739C623DDAF4A1F6DB
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -2 maxlevel 200 minaction 2 bait 0 mail/h: 31 total 5715949 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 00:42 +0100, Andi Kleen wrote:
> > I appear to have misread d_find_alias(). It would seem that the only way
> > to ensure that a mountpoint won't be found is to remove it altogether
> > from the inode->i_dentry list. AFAICS that should be largely harmless
> > since the nfs sb->s_root is never visible to users, and is never part of
> > a dentry tree.
> 
> Hasn't BUGed so far with this patch. I'll watch it further but it looks
> good so far. Thanks. I would suggest to push the patch.
> 
> -Andi

Thanks Andi! I'll push it together with the other patches asap.

Cheers
  Trond

