Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYC3WTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYC3WTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYC3WTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:19:47 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:40560 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbYC3WTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:19:47 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Mon, 31 Mar 2008 00:19:44 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200803302309.52493.chunkeey@web.de> <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803310019.45219.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX192WnX+8q7in/KvccAy/7oNRPyFsvJ966oAEagJ
	HOKIKSxJnPDyAWM3vhUcSucAPGbYO5BGwfi+98vv0iYaCsYJcn
	auMGvcHA0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 March 2008 23:36:40 Thomas Gleixner wrote:
> On Sun, 30 Mar 2008, Chr wrote:
> > > > it's "hpet" (in both cases...)
> > >
> > > Hmm. That should be stable. Which clock is jumping back and forth ?
> > > The one in the logs or the system clock ?
> >
> > The one in the logs... (but it's because of the TSC, right?)
>
> Yes. I thought this was fixed already in Linus tree, but I might be
> wrong as usual.
>
> Anyway, that's not the real problem; I read your original post in
> meantime :)
>
> > Ever since I went to the new 2.6.25-rcX ...
>
> Did this problem start with 25-rc1 ? What is the latest version you
> tried ?
I had other problems with 25-rc1 as well.. but this one is now gone with
the dm-crypto update. I'll try rc1 tomorrow...
>
> > [ 5215.101875]  [<ffffffff80217d8f>] __smp_call_function_mask+0x90/0xc5
> > [ 5215.108493]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> > [ 5215.114422]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> > [ 5215.120348]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> > [ 5215.126276]  [<ffffffff80217e0d>] smp_call_function_mask+0x49/0x61
> > [ 5215.132723]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> > [ 5215.138649]  [<ffffffff802339a3>] on_each_cpu+0x10/0x2c
> > [ 5215.144135]  [<ffffffff8029fb4b>] kill_bdev+0x1e/0x33
> > [ 5215.149456]  [<ffffffff802a01da>] __blkdev_put+0x4f/0x128
> > [ 5215.155124]  [<ffffffff8027dd93>] __fput+0xa1/0x164
> > [ 5215.160272]  [<ffffffff8027b67d>] filp_close+0x5d/0x65
> > [ 5215.165679]  [<ffffffff80231072>] put_files_struct+0x66/0xc4
> > [ 5215.171607]  [<ffffffff802323ea>] do_exit+0x245/0x64c
> > [ 5215.176925]  [<ffffffff80238b94>] __dequeue_signal+0xff/0x159
> > [ 5215.182941]  [<ffffffff80232867>] do_group_exit+0x76/0x93
> > [ 5215.188606]  [<ffffffff8023a0fd>] get_signal_to_deliver+0x2b9/0x2e5
> > [ 5215.195141]  [<ffffffff8020a466>] do_notify_resume+0xaf/0x7e0
> > [ 5215.201155]  [<ffffffff80291414>] mntput_no_expire+0x1f/0x86
> > [ 5215.201155]  [<ffffffff80291414>] mntput_no_expire+0x1f/0x86
>
> You mentioned that you have tons of other logs. Can you please
> upload those to some place? If you don't have a possiblity, please
> contact me private and I'll provide you one.
>
http://www.file-upload.net/download-758265/logs.tar.bz2.html
and hit Download. ;-)

(BTW, the you can ignore some logs like freeze7, ... I tried
nolapic, but that doesn't play well with SATA?!)

Regards,
	Chr
