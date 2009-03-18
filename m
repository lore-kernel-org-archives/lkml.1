Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZCRE71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZCRE71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZCRE7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:59:17 -0400
Received: from mga06.intel.com ([134.134.136.21]:14049 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750782AbZCRE7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,382,1233561600"; 
   d="scan'208";a="395395932"
Message-ID: <49C07F96.2070306@linux.intel.com>
Date: Tue, 17 Mar 2009 21:59:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: linux-next - request_module_nowait() breaks iptables and iwl3945
References: <3823.1237168684@turing-police.cc.vt.edu> <200903171627.58963.rusty@rustcorp.com.au> <39126.1237328835@turing-police.cc.vt.edu> <200903181442.16570.rusty@rustcorp.com.au>
In-Reply-To: <200903181442.16570.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 18 March 2009 08:57:15 Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 17 Mar 2009 16:27:58 +1030, Rusty Russell said:
>>> On Monday 16 March 2009 12:28:04 Valdis.Kletnieks@vt.edu wrote:
>>>> On recent linux-next, iptables and iwl3945 would fail to load
>>> Please send .config; I can't reproduce this here.
>> [root@turing-police ~]# /etc/init.d/iptables start
>> iptables: Applying firewall rules: 
>> iptables-restore v1.4.2: iptables-restore: unable to initialize table 'filter'
> 
> OK, I think this might fix it.  It's already queued, but was labelled a mere
> "cleanup".

I wouldn't understand how it would fix it though;
the code before my patch passes in a 1, and the code after my patch passes in a variable
which has the value 1 as well.... using a symbolic name for it instead isn't going
to impact the generated code afaics...
