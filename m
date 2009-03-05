Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCETiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCETiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZCETiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:38:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:37870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZCETiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:38:04 -0500
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236280076.5187.403.camel@laptop>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
	 <1236279393.3316.13.camel@localhost.localdomain>
	 <1236280076.5187.403.camel@laptop>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 01:07:37 +0530
Message-Id: <1236281857.3316.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 20:07 +0100, Peter Zijlstra wrote:
> On Fri, 2009-03-06 at 00:26 +0530, Jaswinder Singh Rajput wrote:
> > 
> > With fresh copy, perfstat is working.
> > 
> > But kerneltop is still not working and I am not getting any NMI Interrupts.
> 
> What does your dmegs look like?
> 
> Mine read like:
> 
> [    0.012002] AMD Performance Monitoring support detected.
> [    0.013002] ... num counters:    4
> [    0.014001] ... value mask:      0000ffffffffffff
> [    0.015001] ... fixed counters:  0
> [    0.016001] ... counter mask:    000000000000000f
> 

[    0.010998] AMD Performance Monitoring support detected.
[    0.011006] ... num counters:    4
[    0.011301] ... value mask:      0000000000000086
[    0.011581] ... fixed counters:  0
[    0.011808] ... counter mask:    000000000000000f
[    0.011998] ACPI: Core revision 20081204

> and its generating IRQs:
> 
> CNT:     168612     166040   Performance counter interrupts
> 

NMI:          0          0   Non-maskable interrupts
LOC:        213     980394   Local timer interrupts
CNT:          0          0   Performance counter interrupts
RES:     125349     123542   Rescheduling interrupts

--
JSR

