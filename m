Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbZKXOmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbZKXOmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbZKXOmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:42:14 -0500
Received: from mga10.intel.com ([192.55.52.92]:29844 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933083AbZKXOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:42:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,279,1257148800"; 
   d="scan'208";a="749953612"
Message-ID: <4B0BF0CA.5020600@linux.intel.com>
Date: Tue, 24 Nov 2009 06:42:18 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Yong Zhang <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance
 hints
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>	 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>	 <1258968980.2697.9.camel@ppwaskie-mobl2> <1258995923.4531.715.camel@laptop>	  <4B0B782A.4030901@linux.intel.com> <1259051986.4531.1057.camel@laptop>
In-Reply-To: <1259051986.4531.1057.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>> Same for userspace.
>> the problem is that there is no way currently that the driver can communicate
>> "I allocated all my metadata on THIS numa node". irqbalance and sysadmins need
>> that to not make really stupid decisions.....
> 
> And what exactly is struct device::numa_node good for then?
> 

and that is exported to userspace.. how?

... that has nothing to do with an irq, and also falls flat for a driver that
supports multiple irqs, and assigns one to each numa node.


