Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZJFSIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZJFSIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbZJFSIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:08:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbZJFSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:08:37 -0400
Subject: Re: [v7 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
 management code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
 cpuidle to POWER.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20091006163521.GA10425@linux.vnet.ibm.com>
References: <20091006152421.GA7278@linux.vnet.ibm.com>
	 <20091006163521.GA10425@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 20:04:39 +0200
Message-Id: <1254852279.17055.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 22:05 +0530, Arun R Bharadwaj wrote:

> Also, the per-cpu nature of registration/unregistration of cpuidle
> has been maintained as ACPI needs this.

Right, so can't we ditch that and have acpi default to the lowest common
C-state and warn when various cpus report different C-states?



