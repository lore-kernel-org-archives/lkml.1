Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0AJUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0AJUIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389Ab0AJUIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:08:19 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:55178 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab0AJUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:08:18 -0500
Subject: Re: [2.6.33-rc3] NFS4 and dentry issues...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: linux-nfs@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2221001090632m7fdd77qc73c203840a2a78e@mail.gmail.com>
References: <6278d2221001090632m7fdd77qc73c203840a2a78e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 15:08:13 -0500
Message-ID: <1263154093.2987.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 3 sum msgs/h 1 total rcpts 2197 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 084F126717F10FA5777703DA0A1233BDF64FEB5A
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 87 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 14:32 +0000, Daniel J Blueman wrote: 
> When synchronising files (unison, like a two way rsync) over an NFS4
> mount (server with 2.6.32.2) on a client running 2.6.33-rc3 (also
> -rc2), I ran into dcache issues [1].
> 
> I've been unable to consistently reproduce this for bisecting, and
> filesystem benchmarks via NFS on tmpfs over localhost fails to
> reproduce it either.
> 
> What additional information may be useful?

There is a known issue in 2.6.33-rc3 with rename causing corruption of
the dentry lookup hash lists.

A fix for that problem has already been merged into mainline as
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=56335936de1a41c8978fde62b2158af77ddc7258

Could you see if you can reproduce your problem with that fix applied?

Cheers
  Trond

