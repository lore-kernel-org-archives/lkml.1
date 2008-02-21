Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbYBUJsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbYBUJsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYBUJsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:48:43 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59330 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYBUJsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:48:42 -0500
Message-ID: <47BD479F.6070901@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 15:12:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com> <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com> <1203586980.6243.124.camel@lappy>
In-Reply-To: <1203586980.6243.124.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-02-21 at 15:01 +0530, Balbir Singh wrote:
> 
>> I have an alternate approach in mind (that I need to find time for),
>> threaded-rbtrees. Walking the tree is really efficient, specially finding
>> successor of a node.
> 
> Threading the rbtrees would be even more expensive, it would require a
> list_head in each node and a full list operation for every tree
> operation.
> 

Peter, when I say threaded, I don't mean threaded as in tasks. Please see
http://www.nist.gov/dads/HTML/threadedtree.html and
http://datastructures.itgo.com/trees/tbt.htm

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
