Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbYFDKt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbYFDKt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYFDKtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:49:20 -0400
Received: from www.tglx.de ([62.245.132.106]:55961 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbYFDKtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:49:19 -0400
Date: Wed, 4 Jun 2008 12:48:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org, davej@codemonkey.org.uk,
       andi@firstfloor.org
Subject: Re: aperture_64.c: corner case wrong
In-Reply-To: <20080604104438.GA5522@elte.hu>
Message-ID: <alpine.LFD.1.10.0806041247300.3235@apollo.tec.linutronix.de>
References: <20080526191730.GA18425@elf.ucw.cz> <20080602153033.2d1672f0.akpm@linux-foundation.org> <alpine.LFD.1.10.0806031551330.3235@apollo.tec.linutronix.de> <20080604104438.GA5522@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > So what happened with this?  Thomas has merged an "x86: 
> > > aperture_64.c: cleanups" from yourself but it appears that half of 
> > > this bugfix got applied somewhere and the below part did not?
> > 
> > Err, no. I seem to have dropped the patch completely. I'm picking it 
> > up again.
> 
> no, it was not dropped (we dont drop patches :), here are all the 
> arch/x86/kernel/aperture_64.c patches in -tip:
> 
>  earth4:~/tip> tip-log arch/x86/kernel/aperture_64.c | grep ^#
>  # x86/gart: 1edc1ab: x86: agp_gart size checking for buggy device
>  # x86/gart: 8c9fd91: x86: checking aperture size order
>  # x86/gart: 7677b2e: x86_64: allocate gart aperture from 512M
>  # x86/gart: 55c0d72: x86: clean up aperture_64.c
>  # x86/gart: 0abbc78: x86, aperture_64: use symbolic constants
>  # x86/gart: dd564d0: x86: aperture_64.c: cleanups
> 
> so it's commit dd564d0 - but that second chunk Andrew noticed indeed 
> went missing in action.

No, the patch was titled: ".... - corner case wrong" its missing and
I'm wondering why.

/me digs into git branches

Thanks,
	tglx
