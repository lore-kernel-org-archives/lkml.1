Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZEOIaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZEOIaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761165AbZEOI3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:29:38 -0400
Received: from www.tglx.de ([62.245.132.106]:53055 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761125AbZEOI3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:29:36 -0400
Date: Fri, 15 May 2009 10:28:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Janne Kulmala <janne.t.kulmala@tut.fi>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: idle: rename lapic timer workaround routines
In-Reply-To: <alpine.LFD.2.00.0905150217220.4995@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905151028080.3561@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl> <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain> <4A0855A5.8040109@tut.fi> <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain> <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain> <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain> <alpine.LFD.2.00.0905150138001.10065@localhost.localdomain>
 <alpine.LFD.2.00.0905150217220.4995@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Len Brown wrote:

> From: Len Brown <len.brown@intel.com>
> 
> cosmetic only.  The lapic_timer workaround routines
> are specific to the lapic_timer, and are not acpi-generic.
> 
> old:
> 
> acpi_timer_check_state()
> acpi_propagate_timer_broadcast()
> acpi_state_timer_broadcast()
> 
> new:
> 
> lapic_timer_check_state()
> lapic_timer_propagate_broadcast()
> lapic_timer_state_broadcast()
> 
> also, simplify the code in acpi_processor_power_verify()
> so that lapic_timer_check_state() is simply called
> from one place for all valid C-states, including C1.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

