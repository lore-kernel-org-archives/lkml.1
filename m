Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZFEFNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZFEFNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZFEFNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:13:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48650 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZFEFNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:13:22 -0400
Date: Fri, 5 Jun 2009 13:13:16 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Avi Kivity <avi@redhat.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605051316.GC11755@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <4A28A882.8070503@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A28A882.8070503@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen <cfriesen@nortel.com> [2009-06-04 23:09:22]:

> Balbir Singh wrote:
> 
> > But then there is no other way to make a *guarantee*, guarantees come
> > at a cost of idling resources, no? Can you show me any other
> > combination that will provide the guarantee and without idling the
> > system for the specified guarantees?
> 
> The example given was two 10% guaranteed groups and one best-effort
> group.  Why would this require idling resources?
> 
> If I have a hog in each group, the requirements would be met if the
> groups got 33, 33, and 33.  (Or 10/10/80, for that matter.)  If the
> second and third groups go idle, why not let the first group use 100% of
> the cpu?
> 
> The only hard restriction is that the sum of the guarantees must be less
> than 100%.
>

Chris,

I just responded to a variation of this, I think that some of this
could be handled during design. I just sent out the email a few
minutes ago. Could you look at that and respond. 

-- 
	Balbir
