Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZFEOy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZFEOy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZFEOyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:54:20 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:45907 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZFEOyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:54:19 -0400
Message-ID: <4A293196.2060006@nortel.com>
Date: Fri, 05 Jun 2009 08:54:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com> <20090605053159.GB3872@in.ibm.com> <4A28B4CE.4010004@redhat.com> <20090605093947.GJ11755@balbir.in.ibm.com> <4A291A2F.3090201@redhat.com>
In-Reply-To: <4A291A2F.3090201@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 14:54:17.0511 (UTC) FILETIME=[800CEB70:01C9E5ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:

> I am selling virtual private servers.  A 10% cpu share costs $x/month, 
> and I guarantee you'll get that 10%, or your money back.  On the other 
> hand, I want to limit cpu usage to that 10% (maybe a little more) so 
> people don't buy 10% shares and use 100% on my underutilized servers.  
> If they want 100%, let them pay for 100%.

What about taking a page from the networking folks and specifying cpu
like a networking SLA?

Something like "group A is guaranteed X percent (or share) of the cpu,
but it is allowed to burst up to Y percent for Z milliseconds"

If a rule of this form was the first-class citizen, it would provide
both guarantees, limits, and flexible behaviour.

Chris
