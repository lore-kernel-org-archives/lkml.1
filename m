Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZCLWtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZCLWtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZCLWtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:49:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:29697 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZCLWtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,353,1233561600"; 
   d="scan'208";a="672532735"
Subject: Re: [PATCH] VM, x86, PAT: Change implementation of
 is_linear_pfn_mapping
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
In-Reply-To: <200903122130.23860.elendil@planet.nl>
References: <498B5ADE.3090602@vmware.com>
	 <200903120645.44515.elendil@planet.nl>
	 <20090312185918.GA22421@linux-os.sc.intel.com>
	 <200903122130.23860.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 15:48:10 -0700
Message-Id: <1236898090.4529.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 13:30 -0700, Frans Pop wrote:
> On Thursday 12 March 2009, Pallipadi, Venkatesh wrote:
> > OK, Looking more at the code, I now understand how the patch from
> > yday resulted in the oops you saw. Here goes my nth attempt at solving
> > this problem. Can you please test this patch.
> 
> System has been running stable for almost an hour now with pat enabled, so 
> it looks like the problem is solved.
> 
> FYI, with early .29 RCs I had the following when running VirtualBox:
> kernel: WARNING: at arch/x86/mm/pat.c:620 reserve_pfn_range+0x5b/0x26d()
> 
> After be03d9e80220 (which probably fixed that) VirtualBox could no longer 
> be loaded at all with pat enabled, but with this patch added VirtualBox 
> runs perfectly again.

That's great news :-).

Ingo: considering the history of this patch, can you let this cook in
your tree for a week or so and then push towards upstream-git (and .29
stable if .29 is out by then).

Thanks,
Venki

