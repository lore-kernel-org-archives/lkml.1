Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYAOKR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYAOKR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYAOKRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:17:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYAOKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:17:21 -0500
Date: Tue, 15 Jan 2008 02:17:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TSC && HPET calibration
Message-Id: <20080115021720.ad71605f.akpm@linux-foundation.org>
In-Reply-To: <20080110123612.M81049@visp.net.lb>
References: <20080110123612.M81049@visp.net.lb>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 14:36:12 +0200 "Denys Fedoryshchenko" <denys@visp.net.lb> wrote:

> Hi
> 
> I have same issue, but it's never passed synchronization.
> 
> Jan 10 12:59:44 visp-1 Time: tsc clocksource has been installed.
> Jan 10 13:41:51 visp-1 ACPI: HPET 000F29CD, 0038 (r1 DELL   PE_SC3          1 
> DELL        1)
> Jan 10 13:41:51 visp-1 ACPI: HPET id: 0x8086a201 base: 0xfed00000
> Jan 10 13:41:51 visp-1 hpet clockevent registered
> Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#2]:
> Jan 10 13:41:51 visp-1 Measured 1020 cycles TSC warp between CPUs, turning 
> off TSC clock.
> Jan 10 13:41:51 visp-1 Marking TSC unstable due to: check_tsc_sync_source 
> failed.
> Jan 10 13:41:51 visp-1 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> Jan 10 13:41:51 visp-1 hpet0: 3 64-bit timers, 14318180 Hz
> Jan 10 13:41:51 visp-1 Time: hpet clocksource has been installed.
> 
> grep Measures
> Sep 19 14:31:28 visp-1 Measured 1044 cycles TSC warp between CPUs, turning 
> off TSC clock.
> Sep 19 18:22:46 visp-1 Measured 996 cycles TSC warp between CPUs, turning off 
> TSC clock.
> Sep 19 18:35:44 visp-1 Measured 1080 cycles TSC warp between CPUs, turning 
> off TSC clock.

Which kernel version?
