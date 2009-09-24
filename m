Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZIXMZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZIXMZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZIXMZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:25:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:34123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZIXMZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:25:48 -0400
Date: Thu, 24 Sep 2009 14:22:28 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: arun@linux.vnet.ibm.com
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-acpi@vger.kernel.org
Subject: Re: [v6 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
 management code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
 cpuidle to POWER.
Message-ID: <20090924142228.5a2ddf59@infradead.org>
In-Reply-To: <20090924051238.GA5963@linux.vnet.ibm.com>
References: <20090922112526.GA7788@linux.vnet.ibm.com>
	<20090924051238.GA5963@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 10:42:41 +0530
Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:

> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 16:55:27]:
> 
> Hi Len, (or other acpi folks),
> 
> I had a question regarding ACPI-cpuidle interaction in the current
> implementation.
> 
> Currently, every cpu (i.e. acpi_processor) registers to cpuidle as
> a cpuidle_device. So every cpu has to go through the process of
> setting up the idle states and then registering as a cpuidle device.
> 
> What exactly is the reason behind this?
> 

technically a BIOS can opt to give you C states via ACPI on some cpus,
but not on others.

in practice when this happens it tends to be a bug.. but it's
technically a valid configuration



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
