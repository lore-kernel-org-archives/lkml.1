Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZFHXsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZFHXsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZFHXse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:48:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42810 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbZFHXse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:48:34 -0400
Date: Tue, 9 Jun 2009 00:48:30 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for
	VIA/Centaur CPUs
Message-ID: <20090608234830.GA27843@srcf.ucam.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090608102754.GP4106@prithivi.gnumonks.org> <200906081503.30488.lkml@morethan.org> <200906081615.25973.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906081615.25973.lkml@morethan.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 04:15:22PM -0500, Michael S. Zick wrote:

> Phooey, close but no cigar - - -
> 
> root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_available_frequencies
> 1200000 1000000 800000 600000 400000
> root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat stats/time_in_state
> 1200000 3281
> 1000000 120
> 800000 130
> 600000 234
> 400000 52980
> root@cb01:/sys/devices/system/cpu/cpu0/cpufreq
> 
> It loads, it appears to work, but that lowest 400Mhz has ACPI entries
> even though this is a 600Mhz..1200Mhz chip.

If the BIOS tables claim it then it's likely Windows uses it on the same 
hardware. What's the stability like with the ACPI code?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
