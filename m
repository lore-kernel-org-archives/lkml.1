Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYAONyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYAONyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYAONya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:54:30 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:38331 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYAONy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:54:29 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TSC && HPET calibration
Date: Tue, 15 Jan 2008 15:54:12 +0200
Message-Id: <20080115135318.M68697@visp.net.lb>
In-Reply-To: <20080115021720.ad71605f.akpm@linux-foundation.org>
References: <20080110123612.M81049@visp.net.lb> <20080115021720.ad71605f.akpm@linux-foundation.org>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest, 2.6.24-rc7, and 2.6.23 is the same.

If more information required, tell me. It is btw not latest (not based on 
Core2) Xeon.


On Tue, 15 Jan 2008 02:17:20 -0800, Andrew Morton wrote
> On Thu, 10 Jan 2008 14:36:12 +0200 "Denys Fedoryshchenko" 
> <denys@visp.net.lb> wrote:
> 
> > Hi
> > 
> > I have same issue, but it's never passed synchronization.
> > 
> > Jan 10 12:59:44 visp-1 Time: tsc clocksource has been installed.
> > Jan 10 13:41:51 visp-1 ACPI: HPET 000F29CD, 0038 (r1 DELL   
PE_SC3          1 
> > DELL        1)
> > Jan 10 13:41:51 visp-1 ACPI: HPET id: 0x8086a201 base: 0xfed00000
> > Jan 10 13:41:51 visp-1 hpet clockevent registered
> > Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#1]: 
passed.
> > Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#2]:
> > Jan 10 13:41:51 visp-1 Measured 1020 cycles TSC warp between CPUs, 
turning 
> > off TSC clock.
> > Jan 10 13:41:51 visp-1 Marking TSC unstable due to: check_tsc_sync_source 
> > failed.
> > Jan 10 13:41:51 visp-1 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > Jan 10 13:41:51 visp-1 hpet0: 3 64-bit timers, 14318180 Hz
> > Jan 10 13:41:51 visp-1 Time: hpet clocksource has been installed.
> > 
> > grep Measures
> > Sep 19 14:31:28 visp-1 Measured 1044 cycles TSC warp between CPUs, 
turning 
> > off TSC clock.
> > Sep 19 18:22:46 visp-1 Measured 996 cycles TSC warp between CPUs, turning 
off 
> > TSC clock.
> > Sep 19 18:35:44 visp-1 Measured 1080 cycles TSC warp between CPUs, 
turning 
> > off TSC clock.
> 
> Which kernel version?


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

