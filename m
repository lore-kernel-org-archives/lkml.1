Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYIPR4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYIPR4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYIPR4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:56:32 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:19360 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYIPR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kxxWHQOM5VD7YSq2MhF8msuLk5r+Z08/5kq2Zj9rni97ggMbicC0fxSv+mxM9+JAWR
         R8UxnQVDhrj0sIEa7H93O0uL7YHa/JcceEUl0syFPRHC10As7L6JdOYGvBx1BxuH6ii4
         E2d/glTLWeYptdBmf9n2lIrO0ZvJp2m50iHp8=
Date: Tue, 16 Sep 2008 21:56:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Joshua Hoblitt <josh@hoblitt.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, j_kernel@hoblitt.com
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080916175629.GE7187@lenovo>
References: <bug-11543-10286@http.bugzilla.kernel.org/> <20080911170258.aa0bea0d.akpm@linux-foundation.org> <20080912091308.GA10305@elte.hu> <20080913001306.GA9610@hoblitt.com> <20080915210635.GA16764@hoblitt.com> <20080916025431.GB16764@hoblitt.com> <alpine.LFD.1.10.0809160711360.3606@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809160711360.3606@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Gleixner - Tue, Sep 16, 2008 at 07:14:40AM -0700]
| On Mon, 15 Sep 2008, Joshua Hoblitt wrote:
| 
| > In addition to the deadlocks, we still have the watchdog warning:
| > 
| > [    0.460034] Testing NMI watchdog ... 
| > [    0.532557] WARNING: CPU#0: NMI appears to be stuck (0->0)!
| > [    0.533301] Please report this to bugzilla.kernel.org,
| > [    0.536635] and attach the output of the 'dmesg' command.
| > 
| > Perhaps an HPET problem:
| > 
| > [    0.993800] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
| > [    0.999969] hpet0: 3 32-bit timers, 25000000 Hz
| > [    1.004396] ACPI: RTC can wake from S4
| > [    1.006637] Clockevents: could not switch to one-shot
| > mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
| > [    1.009844] Could not switch to high resolution mode on CPU 3
| > [    1.009848] Clockevents: could not switch to one-shot mode: lapic is not functional.
| > [    1.009852] Could not switch to high resolution mode on CPU 2
| > [    1.009855] Clockevents: could not switch to one-shot mode: lapic is not functional.
| > [    1.009858] Could not switch to high resolution mode on CPU 1
| > [    1.009969]  lapic is not functional.
| > [    1.056944] Could not switch to high resolution mode on CPU 0
| 
| No, that's documented behaviour:
| 
| > > > [    0.126660] APIC timer registered as dummy, due to nmi_watchdog=1!
| 
| Can you try nmi_watchdog=2 ?
| 
| Thanks,
| 
| 	tglx
| 

And get apic=debug a try too please. I remember there
was a problem with SB600 on ACPI side (but they should
be already fixed)

		- Cyrill -
