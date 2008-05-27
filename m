Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYE0PZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYE0PZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYE0PZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:25:42 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57820 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbYE0PZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:25:41 -0400
Date: Tue, 27 May 2008 20:57:06 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527152706.GH5181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Michael Neuling <mikey@neuling.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <483AF25B.6090806@linux.vnet.ibm.com> <20080526110040.5ddc4656@infradead.org> <483B0348.2000204@linux.vnet.ibm.com> <20080526115108.6a19e2c0@infradead.org> <483C059B.9040301@linux.vnet.ibm.com> <20080527131926.GB5181@dirshya.in.ibm.com> <20080527071532.7a01608b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080527071532.7a01608b@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2008-05-27 07:15:32]:

> On Tue, 27 May 2008 18:49:26 +0530
> > At any time we will have both the traditional utilisation value
> > relative to current CPU capacity, and scaled utilisation that is
> > relative to maximum CPU capacity.
> > 
> 
> this is where I raise a red flag *because the patch is not doing
> that* !!

Your concern is valid.  I assume you are objecting to the usefulness
and interpretation of the scaled metric and not to the fact that both
scaled and default non scaled metrics are independently available.
 
> sadly it gives a random metric which in some circumstances looks like
> it does that, but in reality it is not doing that.

I agree and I am interested in designing a metric that is useful in
most circumstances.  I am open to suggestions to cover the case of
power constraint and acceleration scenario.

Thanks,
Vaidy

