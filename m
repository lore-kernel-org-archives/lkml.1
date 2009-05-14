Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZENPBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZENPBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZENPBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:01:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42152 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZENPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:01:07 -0400
Date: Thu, 14 May 2009 17:06:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation sched_max_capacity_pct=n
Message-ID: <20090514150632.GG10933@one.firstfloor.org>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins> <20090513150100.GW19296@one.firstfloor.org> <1242226927.26820.30.camel@twins> <20090513151054.GY19296@one.firstfloor.org> <20090514145045.GH4853@dirshya.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514145045.GH4853@dirshya.in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think 'scheduler throttling' is good so that we avoid the term 'CPU
> throttling' or core throttling.  I had named this cpu evacuation or
> core evacuation just to avoid confusion with hardware throttling.

Evacuation sounds good, although shouldn't it be package or 
socket evacuation?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
