Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbYARVC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbYARVC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765468AbYARVCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:02:48 -0500
Received: from ns.suse.de ([195.135.220.2]:32964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066AbYARVCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:02:46 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX II
Date: Fri, 18 Jan 2008 22:02:43 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Oeser <ioe-lkml@rameria.de>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080118183011.354965000@sgi.com> <479108C3.1010800@sgi.com> <200801182136.15213.ak@suse.de>
In-Reply-To: <200801182136.15213.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801182202.43151.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Here are the top stack consumers with NR_CPUS = 4k.
> > 
> >                          16392 isolated_cpu_setup
> >                          10328 build_sched_domains
> >                           8248 numa_initmem_init
> 
> These should run single threaded early at boot so you can probably just make
> the cpumask_t variables static __initdata


To correct myself: this is not true for build_sched_domains() which can
be triggered from sysfs.

-Andi
