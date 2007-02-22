Return-Path: <linux-kernel-owner+w=401wt.eu-S1945997AbXBVMhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997AbXBVMhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946004AbXBVMhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:37:35 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:42757 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945997AbXBVMhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:37:34 -0500
Date: Thu, 22 Feb 2007 13:36:43 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
In-Reply-To: <1172099859.25076.132.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
 <1172099859.25076.132.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 22 2007 00:17, Thomas Gleixner wrote:
>On Thu, 2007-02-22 at 00:04 +0100, Luca Tettamanti wrote:
>> 
>> Interrupt 0 is stuck at 114 (the number is consistent across reboots). I
>> don't experience any problem, time is running fine. Still it's strange
>> that the timer is doing nothing; maybe something other than the PIT is
>> used for time keeping?
>
>Yes, we switch away from PIT and use the local APIC timer. (LOC)

What's the benefit of doing so - and why has not it been done before?
I mean, I run a regular 2.6.18.6,
/sys/devices/system/clocksource/clocksource0/current_clocksource (is this
related?) shows "acpi_pm", but the IRQ0 counter increases at HZ. Maybe I
am confusing things, but why the need for PIT when clocksource is acpi_pm
anyway?


Jan
-- 
