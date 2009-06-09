Return-Path: <linux-kernel-owner+w=401wt.eu-S1760414AbZFIMhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414AbZFIMhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZFIMgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:36:55 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:37767 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZFIMgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:36:55 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Tue, 9 Jun 2009 07:36:52 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906081615.25973.lkml@morethan.org> <20090608234830.GA27843@srcf.ucam.org>
In-Reply-To: <20090608234830.GA27843@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906090736.54463.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Matthew Garrett wrote:
> On Mon, Jun 08, 2009 at 04:15:22PM -0500, Michael S. Zick wrote:
> 
> > Phooey, close but no cigar - - -
> > 
> > root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_available_frequencies
> > 1200000 1000000 800000 600000 400000
> > root@cb01:/sys/devices/system/cpu/cpu0/cpufreq# cat stats/time_in_state
> > 1200000 3281
> > 1000000 120
> > 800000 130
> > 600000 234
> > 400000 52980
> > root@cb01:/sys/devices/system/cpu/cpu0/cpufreq
> > 
> > It loads, it appears to work, but that lowest 400Mhz has ACPI entries
> > even though this is a 600Mhz..1200Mhz chip.
> 
> If the BIOS tables claim it then it's likely Windows uses it on the same 
> hardware. What's the stability like with the ACPI code?
> 

Too soon to say - those where first results (about par with "it boots"). ;)

Will be poking at this machine more today -

* * * *

I do not have a copy of any proprietary operating system to compare with
on this machine.

You could use the search features of this forum:
http://forum.netbookuser.com/index.php
to look for windows problem reports/discussions.

That forum was active since the machine was announced and included
members from Everex.  If there where windows problems, they are
in there somewhere.

Mike
