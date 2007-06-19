Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXFSB43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXFSB43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760946AbXFSB4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:56:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34366 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693AbXFSB4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:56:13 -0400
Subject: Re: [patch-mm 00/25] High resolution timer updates and x86_64
	support - V2
From: Arjan van de Ven <arjan@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <6972.1182197191@turing-police.cc.vt.edu>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
	 <6972.1182197191@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 18 Jun 2007 18:52:58 -0700
Message-Id: <1182217979.3014.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 16:06 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 16 Jun 2007 10:36:00 -0000, Thomas Gleixner said:
> > The following patch series contains:
> > 
> > - dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)
> > 
> > - updates and improvements to high resolution timer / dynticks 
> > 
> > - high resolution timer / dynticks support for x86_64
> 
> Am running with the 22-rc4-mm2-hrt4 patch on my Latitude D820.  Mostly seems
> to work, but for some reason the Intel 'powertop' util thinks it's 100% busy:
> 
>      PowerTOP version 1.7       (C) 2007 Intel Corporation
> 
> Cn          Avg residency (5s)          P-states (frequencies)
> C0 (cpu running)        (100.0%)
> C1                0.0ms ( 0.0%)         2.00 Ghz     0.0%
> C2                0.0ms ( 0.0%)         1.67 Ghz     0.0%
> C3                0.0ms ( 0.0%)         1333 Mhz     0.0%
>                                         1000 Mhz   100.0%
> 
> In reality:


looks like something broke the /proc/acpi/processor/*/power file
data....

can you check in that file to see if there is actual C-state time
accounting going on?
(it is in mainline, so if it's not then it's an -mm or -hrt bug)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

