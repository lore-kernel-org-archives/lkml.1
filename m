Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYLJBHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYLJBHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYLJBGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:06:52 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:58357 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYLJBGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:06:51 -0500
Subject: Re: Fwd: 2.6.26.3 kernel - progressive slowdown over NFS
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <2c0942db0812091638o3d0fe68ek70744f6938949b25@mail.gmail.com>
References: <f4e12c70809091747rd58165ahaa6594a35752c6ef@mail.gmail.com>
	 <2c0942db0812091638o3d0fe68ek70744f6938949b25@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 20:06:45 -0500
Message-Id: <1228871206.30231.76.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 5151BBD9758DC14C52319EA939C84F6A772C4176
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 249 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 16:38 -0800, Ray Lee wrote:
> [ adding netdev, linux-nfs to cc: -- rbl ]
> 
> Hi,
> 
> 
> We have a simple python program which keeps running a C loop to lstat
> NFS mounted directories.  We are seeing some weird behavior w.r.t. the
> run-time of this program on 2.6.26.3 kernel vs 2.6.24 kernel.
> 
> The run-time of the following code increases over time on the 2.6.26.3
> kernel, whereas remains flat (as expected) on the 2.6.24 kernel.
> [See attached graphs - B1.jpg and B2.jpg]  Once the 2.6.26.3 machine
> gets into this state, we need to restart the box to get back to
> reasonable run-times.  Is this a known issue ?

Could you try applying the following patch?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=23918b03060f6e572168fdde1798a905679d2e06

Trond

PS: note that your 2.6.26 config file has _very_ different memory models
and kernel debugging options enabled compared to your 2.6.24 kernel.
That may also affect performance.

