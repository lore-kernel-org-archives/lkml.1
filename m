Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZFEFJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZFEFJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZFEFJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:09:33 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:41860 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZFEFJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:09:32 -0400
Message-ID: <4A28A882.8070503@nortel.com>
Date: Thu, 04 Jun 2009 23:09:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Avi Kivity <avi@redhat.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com>
In-Reply-To: <20090605044946.GA11755@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 05:09:29.0291 (UTC) FILETIME=[CDD771B0:01C9E59B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

> But then there is no other way to make a *guarantee*, guarantees come
> at a cost of idling resources, no? Can you show me any other
> combination that will provide the guarantee and without idling the
> system for the specified guarantees?

The example given was two 10% guaranteed groups and one best-effort
group.  Why would this require idling resources?

If I have a hog in each group, the requirements would be met if the
groups got 33, 33, and 33.  (Or 10/10/80, for that matter.)  If the
second and third groups go idle, why not let the first group use 100% of
the cpu?

The only hard restriction is that the sum of the guarantees must be less
than 100%.

Chris
