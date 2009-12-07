Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbZLGK4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbZLGK4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932551AbZLGK4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:56:15 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35351 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbZLGK4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:56:14 -0500
Date: Mon, 7 Dec 2009 16:26:16 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Torsten Duwe <duwe@lst.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v10 PATCH 2/9]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20091207105616.GC21290@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091202095427.GA27251@linux.vnet.ibm.com>
 <200912042320.01320.duwe@lst.de>
 <20091206051928.GA18300@linux.vnet.ibm.com>
 <200912071117.58163.duwe@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200912071117.58163.duwe@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Torsten Duwe <duwe@lst.de> [2009-12-07 11:17:57]:

> On Sunday 06 December 2009, Arun R Bharadwaj wrote:
> 
> > Peter objected to the idea of integrating this with the old pm_idle
> > because it has already caused a lot of problems on x86 and we wouldn't
> > want to be doing the same mistake on POWER. The discussion related to
> > that could be found here http://lkml.org/lkml/2009/8/26/233
> 
> And BenH has sketched how it should be done on ppc, in that thread:
> http://lkml.org/lkml/2009/8/26/624 AFAIS this comment is still valid for v10.
> 
> Not only I would like to understand what is the conceptual idea behind the 
> other changes. Nothing wrong with cleanups, but there's got to be a purpose 
> and benefits.
> 
> 	Torsten

The reason for the cleanups is that we should have just one idle
function manager instead of having one for each arch, which needs to
be exported and hence really ugly. So thats why we
decided to do away with pm_idle and make cpuidle as _the_ idle
function manager. So in case of POWER, we have the ppc_md.power_save
which is the pm_idle equivalent. We discussed that in this thread
http://lkml.org/lkml/2009/9/2/20

thanks
arun
