Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYE0PTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYE0PTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbYE0PTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:19:31 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49054 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756223AbYE0PT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:19:29 -0400
Date: Tue, 27 May 2008 20:50:33 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527152033.GG5181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	balbir@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Michael Neuling <mikey@neuling.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <483AF25B.6090806@linux.vnet.ibm.com> <20080526110040.5ddc4656@infradead.org> <483B0348.2000204@linux.vnet.ibm.com> <20080526115108.6a19e2c0@infradead.org> <20080527132909.GC5181@dirshya.in.ibm.com> <20080527071900.25329ae1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080527071900.25329ae1@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2008-05-27 07:19:00]:

> \> > 
> > > that's a case where it really makes sense; it's the case where the
> > > thing that controls the cpu P-state actually learns about how much
> > > work was done to reevaluate what the cpu frequency should be going
> > > forward. Eg it's a case of comparing actual frequency (APERF/MPERF)
> > > to see what's useful to set next.
> > > IDA makes this all needed due to the dynamic nature of the concept
> > > of "frequency".
> > 
> > Scaled statistics relative to maximum CPU capacity is just a method of
> > exposing the actual CPU utilisation of applications independent of CPU
> > frequency changes.
> > 
> > Reason behind the metric is same as the above fact that you have
> > mentioned.  The CPU frequency governors cannot make decisions only
> > based on idle time ratio.  It needs to know current utilisation (used
> > cycles) relative to maximum capacity so that the frequency can be
> > changed to next higher level.
> > 
> > Higher level management software that wants to control CPU capacity
> > externally will need similar information.
> >
> I entirely understand that desire.

Good :)

> But you're not giving it that information!
> The patch is giving it a really poor approximation, an approximation
> that will get worse and worse in upcoming cpu generations.

I agree that power capping and acceleration makes the metric
approximate.  But was are trying to be as accurate and meaningful as
APERF/MPERF ratio is in the processor hardware.

Can I state the problem like this:  The metric is as accurate and
meaningful as APERF/MEPRF ratio, but the interpretation of the metric
is subject to the knowledge of power constraint or acceleration
currently in effect.

--Vaidy

