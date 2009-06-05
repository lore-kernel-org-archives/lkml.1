Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZFEHUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZFEHUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZFEHUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:20:07 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:49587 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZFEHUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:20:06 -0400
Date: Fri, 5 Jun 2009 09:19:02 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Zick" <lkml@morethan.org>, Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090605071902.GD6411@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org> <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:07:37AM -0700, Linus Torvalds wrote:
> 
> 
> Side note: is it more stable if you disable the VIA speedstep thing 
> (whatever it's called (ok, google tells me it's called "TwinTurbo" and 
> "Advanced PowerSaver")?
> 
> Features like that easily put a huge stress on power regulators etc, if 
> they result in sudden changes in current draw.  Underspecced capacitors 
> etc can cause CPU "brown-outs", which in turn can easily cause total 
> failure.

I agree, that might be an interesting test.

As a side note: The C7-M actually uses the same software interface as Intel CPU
for doing the power transitions (ACPI Performance States).   Only very early C7
models used the cpufreq/e_powersaver.c driver.

So if you want to disable it, make sure you disable X86_ACPI_CPUFREQ.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
