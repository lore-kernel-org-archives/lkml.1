Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZFEH1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZFEH1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZFEH1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:27:42 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:55319 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZFEH1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:27:42 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Fri, 5 Jun 2009 02:27:40 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain> <20090605071902.GD6411@prithivi.gnumonks.org>
In-Reply-To: <20090605071902.GD6411@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906050227.42295.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Harald Welte wrote:
> On Thu, Jun 04, 2009 at 10:07:37AM -0700, Linus Torvalds wrote:
> > 
> > 
> > Side note: is it more stable if you disable the VIA speedstep thing 
> > (whatever it's called (ok, google tells me it's called "TwinTurbo" and 
> > "Advanced PowerSaver")?
> > 
> > Features like that easily put a huge stress on power regulators etc, if 
> > they result in sudden changes in current draw.  Underspecced capacitors 
> > etc can cause CPU "brown-outs", which in turn can easily cause total 
> > failure.
> 
> I agree, that might be an interesting test.
> 
> As a side note: The C7-M actually uses the same software interface as Intel CPU
> for doing the power transitions (ACPI Performance States).   Only very early C7
> models used the cpufreq/e_powersaver.c driver.
> 

What is "very early C7 models" in terms of cpuid results?

If you can get permission to reveal those field details -
we can test for that (this build reports "stepping 0" but
I don't trust the report).

Mike
> So if you want to disable it, make sure you disable X86_ACPI_CPUFREQ.
> 


