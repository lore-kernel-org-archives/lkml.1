Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbZHZLcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbZHZLcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZHZLcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:32:21 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44896 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118AbZHZLcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:32:21 -0400
Date: Wed, 26 Aug 2009 17:02:17 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v2 PATCH 2/2]: pseries: Implement Pseries Processor Idle idle
	module.
Message-ID: <20090826113217.GA14758@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090826110721.GA29759@linux.vnet.ibm.com> <20090826111003.GC29759@linux.vnet.ibm.com> <1251286038.1329.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251286038.1329.1.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-08-26 13:27:18]:

> On Wed, 2009-08-26 at 16:40 +0530, Arun R Bharadwaj wrote:
> > +void (*pm_idle)(void);
> > +EXPORT_SYMBOL_GPL(pm_idle);
> 
> Seriously.. this caused plenty problems over on x86 and you're doing the
> exact same dumb thing?
> 

Hi Peter,

Cpuidle assumes pm_idle to be the default idle power management
function. So i should either do this, or change the stuff in cpuidle.c
so that it is more abstract.

--arun
