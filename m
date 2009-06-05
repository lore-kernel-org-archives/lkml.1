Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZFEDHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZFEDHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFEDHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:07:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33485 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZFEDHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:07:33 -0400
Date: Fri, 5 Jun 2009 11:07:30 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: bharata@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, kvm@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605030730.GB28932@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A27BBCA.5020606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2009-06-04 15:19:22]:

> Bharata B Rao wrote:
> > 2. Need for hard limiting CPU resource
> > --------------------------------------
> > - Pay-per-use: In enterprise systems that cater to multiple clients/customers
> >   where a customer demands a certain share of CPU resources and pays only
> >   that, CPU hard limits will be useful to hard limit the customer's job
> >   to consume only the specified amount of CPU resource.
> > - In container based virtualization environments running multiple containers,
> >   hard limits will be useful to ensure a container doesn't exceed its
> >   CPU entitlement.
> > - Hard limits can be used to provide guarantees.
> >   
> How can hard limits provide guarantees?
> 
> Let's take an example where I have 1 group that I wish to guarantee a 
> 20% share of the cpu, and anther 8 groups with no limits or guarantees.
> 
> One way to achieve the guarantee is to hard limit each of the 8 other 
> groups to 10%; the sum total of the limits is 80%, leaving 20% for the 
> guarantee group. The downside is the arbitrary limit imposed on the 
> other groups.
> 
> Another way is to place the 8 groups in a container group, and limit 
> that to 80%. But that doesn't work if I want to provide guarantees to 
> several groups.
>

Hi, Avi,

Take a look at
http://wiki.openvz.org/Containers/Guarantees_for_resources
and the associated program in the wiki page.

-- 
	Balbir
