Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYGXNv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYGXNv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYGXNvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:51:48 -0400
Received: from stinky.trash.net ([213.144.137.162]:37858 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbYGXNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:51:47 -0400
Message-ID: <488888EF.4090005@trash.net>
Date: Thu, 24 Jul 2008 15:51:43 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Dieter Ries <clip2@gmx.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, netdev@vger.kernel.org,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Current Git: BUG: unable to handle kernel paging request at 0000000001a40ca0
References: <488750AA.20707@gmx.de>	 <19f34abd0807231046o4b194409w7d0e28a7cd745afa@mail.gmail.com>	 <48877200.9040608@gmx.de> <4887A860.6070607@gmx.de>	 <19f34abd0807231500m3d780d90i39626023e0685369@mail.gmail.com>	 <48882687.7020508@gmx.de> <84144f020807240649ra4ef475x9f19f1474678ea2f@mail.gmail.com>
In-Reply-To: <84144f020807240649ra4ef475x9f19f1474678ea2f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Thu, Jul 24, 2008 at 9:51 AM, Dieter Ries <clip2@gmx.de> wrote:
>> I think I managed to catch one of those:
>>
>> general protection fault: 0000 [1] SMP
>> CPU 0
>> Modules linked in:
>> Pid: 0, comm: swapper Not tainted 2.6.26-06373-gcaf076e #49
>> RIP: 0010:[<ffffffff805e08f9>]  [<ffffffff805e08f9>]
>> nf_nat_move_storage+0x21/0x7a
>> ...
>> Call Trace:
>>  <IRQ>  [<ffffffff8059d3c4>] __nf_ct_ext_add+0x15f/0x1f7
>>  [<ffffffff805e762c>] nf_nat_fn+0x84/0x152
>>  [<ffffffff805e77d8>] nf_nat_in+0x2f/0x71
> Dieter, can you please try this patch:
> 
> http://lkml.org/lkml/2008/7/24/186
> 
> Patrick, it looks like this could be the same bug Ingo is hitting?

Yes, that most likely the same underlying problem.
