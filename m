Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXLHEdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXLHEdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXLHEcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:32:54 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55046 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbXLHEcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:32:53 -0500
Message-ID: <475A1E6E.3010303@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 10:02:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linuxppc-dev@ozlabs.org, Nathan Lynch <ntl@pobox.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207221106.GH16824@localdomain> <4759C89B.9000709@linux.vnet.ibm.com> <alpine.DEB.0.9999.0712071510370.27689@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.9999.0712071510370.27689@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Sat, 8 Dec 2007, Balbir Singh wrote:
> 
>> Yes, they all appear on node 0. We could have tweaks to distribute CPU's
>> as well.
>>
> 
> You're going to want to distribute the cpu's based on how they match up 
> physically with the actual platform that you're running on.  x86_64 does 

Could you explain this better, how does it match up CPU's with fake NUMA
memory? Is there some smartness there? I'll try and look at the code and
also see what I can do for PowerPC

> this already and it makes fake NUMA more useful because it matches the 
> real-life case more often.

Yes, I agree, but I don't want that to be the first step for fake NUMA
nodes on PowerPC. I think we can incrementally add features.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
