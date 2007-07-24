Return-Path: <linux-kernel-owner+w=401wt.eu-S932751AbXGXBvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbXGXBvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXGXBuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:50:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:40894 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbXGXBux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="271827256"
Subject: Re: [RFC 1/8]KVM: fix bugs in kvm sched integration patch
From: Shaohua Li <shaohua.li@intel.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46A48713.9080404@qumranet.com>
References: <1185173492.2645.65.camel@sli10-conroe.sh.intel.com>
	 <46A48713.9080404@qumranet.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 09:45:44 +0800
Message-Id: <1185241544.24201.15.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 18:46 +0800, Avi Kivity wrote:
> Shaohua Li wrote:
> > fix some bugs in kvm-sch patch.
> >  
> 
> There is now a 'preempt-hooks' branch on kvm.git with the
> preempt-hooks
> work.  I'll continually update and rebase it against master.
> 
> > 1. vmcs_readl/vmcs_writel are called with preempt enabled
> >  
> 
> Why is that bad?
1. raw_smp_processor_id()
2. migrate to other cpu
3. current->kvm_vcpu->cpu != the cpu id of step 1.
you will see the warning.

Thanks,
Shaohua
