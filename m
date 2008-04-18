Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYDROl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYDROl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYDROlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:41:20 -0400
Received: from tornado.reub.net ([59.167.255.179]:37954 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYDROlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:41:19 -0400
X-DKIM: Sendmail DKIM Filter v2.5.2 tornado.reub.net 5B9BA129ACB
Message-ID: <4808B303.1050402@reub.net>
Date: Sat, 19 Apr 2008 00:41:07 +1000
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.15pre (Windows/20080417)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<48089BDE.6040100@reub.net>	<20080418133645.GF31797@elte.hu> <20080418065127.3005c671@laptopd505.fenrus.org>
In-Reply-To: <20080418065127.3005c671@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/04/2008 11:51 PM, Arjan van de Ven wrote:
> On Fri, 18 Apr 2008 15:36:45 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
>>
>>> is enough to prevent my system booting, viz:
>> hm, does it boot up fine with the attached patch and stackprotector 
>> enabled? It appears that your system got to the self-test so 
>> stackprotector is working mostly - it's just that the self-test went 
>> wrong.
>>
> 
> yes it'll be interesting to see if this is due to the test triggering or due to
> something else.
> 
> Reuben:
> I assume your gcc is pretty vanilla and doesn't have weird patches in this area?

I think so.  Well, put it this way... I haven't made any changes to it, this is 
the standard/current gcc that has been in Gentoo Portage for the last while.

 > Can you do a (with the test enabled in the config/code) do a
 > make kernel/panic.s
 > and send me that file? (this allows me to see what code your gcc generated 
for the test)

Done - posted up in the web directory along with the other files (saves the 
possible grief of MUA mangling).

I'm about to reboot to try Ingo's test also.

Reuben

