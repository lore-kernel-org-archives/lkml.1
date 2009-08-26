Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZHZWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZHZWZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZHZWZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:25:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:23617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbZHZWZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:25:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,282,1249282800"; 
   d="scan'208";a="545085803"
Subject: Re: [PATCH] x86: use hard_smp_processor_id to get apic id in
 identify_cpu -v2
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@openvz.org>
In-Reply-To: <4A9587FE.20503@kernel.org>
References: <4A9391CD.5020804@kernel.org>  <4A946082.9090809@kernel.org>
	 <1251240835.2636.28.camel@sbs-t61>  <4A948C88.9060403@kernel.org>
	 <1251308988.2787.39.camel@sbs-t61.sc.intel.com> <4A9587FE.20503@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 26 Aug 2009 15:24:15 -0700
Message-Id: <1251325455.2787.61.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 12:07 -0700, Yinghai Lu wrote:
> Suresh Siddha wrote:
> > 
> > In short, on all the platforms we want to use initial apic id for apicid
> > and phys_proc_id. And only on the required platforms like x445, vsmp,
> > some AMD platforms, we can have their own mechanisms.
> > 
> >> 3. for vsmp, and x445, do you want to have c->apicid to have real apic id or the same as initial apic_id?
> > 
> > On these platforms, c->apicid should be based on their real apic id.
> > 
> >> this patch is trying to make c->apicid to have real apic_id.
> > 
> > Can you please modify the patch so that we can have exceptions for
> > needed platforms only?
> > 
> 
> please check this one
> 
> [PATCH] x86: use hard_smp_processor_id to get apic id for amd k8 cpus
> 
> otherwise, system with apci id lifting will have wrong apicid in
> /proc/cpuinfo
> 
> and use that in srat_detect_node
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

Looks better.

