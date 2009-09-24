Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZIXFNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZIXFNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 01:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZIXFNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 01:13:04 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58325 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZIXFNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 01:13:02 -0400
Date: Thu, 24 Sep 2009 10:42:41 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-acpi@vger.kernel.org
Subject: Re: [v6 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
	management code in x86, cleanup drivers/cpuidle/cpuidle.c and
	introduce cpuidle to POWER.
Message-ID: <20090924051238.GA5963@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922112526.GA7788@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090922112526.GA7788@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 16:55:27]:

Hi Len, (or other acpi folks),

I had a question regarding ACPI-cpuidle interaction in the current
implementation.

Currently, every cpu (i.e. acpi_processor) registers to cpuidle as
a cpuidle_device. So every cpu has to go through the process of
setting up the idle states and then registering as a cpuidle device.

What exactly is the reason behind this?

Is this really necessary or can we have a system-wide one-time registering
to cpuidle by ACPI?

I'm currently in the process of enabling cpuidle for POWER systems and
find that having a system-wide registering mechanism to be a cleaner
design.

--arun
