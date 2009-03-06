Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZCFEYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZCFEYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 23:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZCFEX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 23:23:59 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38191 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZCFEX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 23:23:59 -0500
Date: Fri, 6 Mar 2009 09:53:33 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090306042333.GA9190@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090305161451.0da40645@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090305161451.0da40645@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2009-03-05 16:14:51]:

> On Wed, 4 Mar 2009 17:42:49 +0530
> Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:
> > With the timers queued I measure the sleep state residency
> > for a period of 10s.
> > Next, I enable timer migration and measure the sleep state
> > residency period.
> 
> is your table in seconds? Because realistically, at least on PC like
> hardware, doing work to get sleep times over a 100 / 200 msecs or so
> isn't going to save you any amount of measurable power anymore...
>

Hi Arjan,

Yes, the table is in seconds.
Rather than looking at timer migration as a direct means of obtaining
power savings, I would like to see it as one of the mechanisms which
would aid in preventing an almost idle cpu from waking up
unnecessarily, thereby causing power penalty. Otherwise, there is a
chance of all the CPUs in a particular package being idle and the
entire package going into deep sleep.
So we cannot really get big power savings just by doing timer
migration alone.

--arun

> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
