Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYJaQxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYJaQxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYJaQxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:53:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:24543 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYJaQxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:53:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,523,1220252400"; 
   d="scan'208";a="398325837"
Date: Fri, 31 Oct 2008 09:53:36 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081031165334.GA10468@linux-os.sc.intel.com>
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org> <20081031093924.GG30317@elte.hu> <490AE820.1010301@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490AE820.1010301@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 04:12:32AM -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> Suresh Siddha wrote:
> >>     
> >>> We didn't see the lockup in our tests but Xen folks reported similar failures
> >>> with their smp call function code.
> >>>   
> >>>       
> >> ...really?  I don't remember anything like that, but perhaps I'm 
> >> forgetting something.  In Xen the IPI is sent with a hypercall, 
> >> which is definitely a solid enough barrier for these purposes.
> >>     
> >
> > i think Suresh might be referring to some of the fragilities Xen had 
> > with generic-ipi. But those AFAICT were due to the on-stack lifetime 
> > bug that Nick fixed via the kmalloc? v2.6.26-ish issue.
> 
> Right, that's all I could think of.

No. I am referring to Xen hypervisor code fix recently done by the Xen
team in the Intel.

http://xenbits.xensource.com/xen-unstable.hg?rev/50170dc8649c

thanks,
suresh
