Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbZHSChl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbZHSChl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 22:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZHSChk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 22:37:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:32161 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZHSChj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:37:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,405,1246863600"; 
   d="scan'208";a="177489911"
Date: Wed, 19 Aug 2009 10:37:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and
	'slabinfo'
Message-ID: <20090819023737.GA17710@localhost>
References: <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi> <alpine.DEB.1.10.0908171240370.16267@gentwo.org> <4A8A0B0D.6080400@redhat.com> <4A8A0B14.8040700@cn.fujitsu.com> <4A8A1B2E.20505@redhat.com> <20090818120032.GA22152@localhost> <4A8B652E.40905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8B652E.40905@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 10:36:30AM +0800, Amerigo Wang wrote:
> Wu Fengguang wrote:
> > On Tue, Aug 18, 2009 at 11:08:30AM +0800, Amerigo Wang wrote:
> >
> >   
> >> -	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
> >> +	proc_create("slabinfo",S_IRUGO,NULL,&proc_slabinfo_operations);
> >>     
> >
> > Style nitpick. The spaces were packed to fit into 80-col I guess.
> >
> >   
> 
> Yeah, I noticed this too, the reason I didn't fix this is that I don't 
> want to mix coding style fix with this one. We can fix it in another 
> patch, if you want. :)

Why not? This don't hurt readability of the patch, hehe.
