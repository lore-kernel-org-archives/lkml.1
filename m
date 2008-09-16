Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYIPFoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYIPFoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 01:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYIPFo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 01:44:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:33878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbYIPFo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 01:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,406,1217833200"; 
   d="scan'208";a="439914833"
Date: Mon, 15 Sep 2008 22:44:25 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 0/7] x86, cpa: cpa related changes to be inline with TLB Application note
Message-ID: <20080916054424.GB16486@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com> <20080914152947.GH29290@elte.hu> <20080914165908.GA8775@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914165908.GA8775@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 09:59:08AM -0700, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >
> > applied to tip/x86/pat, thanks Suresh.
> 
> hm, -tip testing found sporadic lockups on a testbox today:
> 

hmm. Me the culprit :(

There are more places in the kernel which takes pgd_lock using
spin_lock_irqsave() construct. Need to fix all such places
to use spin_lock(). Will fix it and send a more tested patch set
early next week, after I return from the conferences.

thanks,
suresh
