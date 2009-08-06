Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZHFPOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZHFPOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZHFPOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:14:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbZHFPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:14:19 -0400
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Shaohua Li <shaohua.li@intel.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>, Balbir Singh <balbir@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1249570998.32113.499.camel@twins>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
	 <20090806015855.GA20596@sli10-desk.sh.intel.com>
	 <20090806043351.GC14333@dirshya.in.ibm.com>
	 <1249570998.32113.499.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Aug 2009 17:13:42 +0200
Message-Id: <1249571622.32113.510.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 17:03 +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-06 at 10:03 +0530, Vaidyanathan Srinivasan wrote:
> > This was the
> > main objection to Venki's deepest sleep state for offline cpus patch.
> 
> Well, my main objection was that is was a single raw function pointer
> without any management layer around it.
> 
> We have the exact same mess with the idle routine - and that has bitten
> us in the past.

That said, I still think it makes sense to share this with the idle
routine, we can make some callbacks unsuitable for hot-unplug just fine.
