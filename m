Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZFEJ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZFEJ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZFEJ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:28:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36588 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbZFEJ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:28:30 -0400
Date: Fri, 5 Jun 2009 14:57:33 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605092733.GA27486@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 01:53:15AM -0700, Paul Menage wrote:
> On Wed, Jun 3, 2009 at 10:36 PM, Bharata B
> Rao<bharata@linux.vnet.ibm.com> wrote:
> > - Hard limits can be used to provide guarantees.
> >
> 
> This claim (and the subsequent long thread it generated on how limits
> can provide guarantees) confused me a bit.
> 
> Why do we need limits to provide guarantees when we can already
> provide guarantees via shares?

shares design is proportional and hence it can't by itself provide
guarantees.

> 
> Suppose 10 cgroups each want 10% of the machine's CPU. We can just
> give each cgroup an equal share, and they're guaranteed 10% if they
> try to use it; if they don't use it, other cgroups can get access to
> the idle cycles.

Now if 11th group with same shares comes in, then each group will now
get 9% of CPU and that 10% guarantee breaks.

Regards,
Bharata.
