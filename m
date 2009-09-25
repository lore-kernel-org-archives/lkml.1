Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZIYHGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZIYHGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIYHGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:06:45 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39211 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZIYHGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:06:44 -0400
Date: Fri, 25 Sep 2009 12:36:23 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: arun@linux.vnet.ibm.com, Len Brown <lenb@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-acpi@vger.kernel.org
Subject: Re: [v6 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
 management code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
 cpuidle to POWER.
Message-ID: <20090925070623.GH8595@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090922112526.GA7788@linux.vnet.ibm.com>
 <20090924051238.GA5963@linux.vnet.ibm.com>
 <20090924142228.5a2ddf59@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090924142228.5a2ddf59@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2009-09-24 14:22:28]:

> On Thu, 24 Sep 2009 10:42:41 +0530
> Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:
> 
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 16:55:27]:
> > 
> > Hi Len, (or other acpi folks),
> > 
> > I had a question regarding ACPI-cpuidle interaction in the current
> > implementation.
> > 
> > Currently, every cpu (i.e. acpi_processor) registers to cpuidle as
> > a cpuidle_device. So every cpu has to go through the process of
> > setting up the idle states and then registering as a cpuidle device.
> > 
> > What exactly is the reason behind this?
> > 
> 
> technically a BIOS can opt to give you C states via ACPI on some cpus,
> but not on others.
> 
> in practice when this happens it tends to be a bug.. but it's
> technically a valid configuration

So we will need to keep the per-cpu registration as of now because we
may have such buggy BIOS in the field and we don't want the cpuidle
framework to malfunction there.

--Vaidy


