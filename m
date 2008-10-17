Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYJQNg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYJQNg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYJQNgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:36:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbYJQNgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:36:17 -0400
Date: Fri, 17 Oct 2008 15:36:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [GIT]: Networking
Message-ID: <20081017133603.GA28600@elte.hu>
References: <20081015.163817.193700221.davem@davemloft.net> <20081017082138.GA23155@elte.hu> <48F87D3E.5020007@trash.net> <20081017120408.GA20030@elte.hu> <48F88660.7080204@netfilter.org> <48F89311.6090208@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48F89311.6090208@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Patrick McHardy <kaber@trash.net> wrote:

> Pablo Neira Ayuso wrote:
>> Ingo Molnar wrote:
>>> * Patrick McHardy <kaber@trash.net> wrote:
>>>
>>>>> net/netfilter/nf_conntrack_netlink.c:819: warning: ‘enum  
>>>>> nf_nat_manip_type’ declared inside parameter list
>>>>> net/netfilter/nf_conntrack_netlink.c:819: warning: its scope is 
>>>>> only this definition or declaration, which is probably not what 
>>>>> you want
>>>>> net/netfilter/nf_conntrack_netlink.c:818: error: parameter 2  
>>>>> (‘manip’) has incomplete type
>>>> Thanks Ingo. I just sent this patch to Benjamin Herrenschmidt
>>>> for testing.
>>>
>>> build still fails with the attached config.
>>
>> This should fix it. I have slightly tested it here with your config.
>>
>
> Applied, thanks Pablo.
>
> I'll look into cleaning up those conditional includes. Its getting 
> more and more complicated to even build-test all the combinations.

yeah - very often build errors in rare .config scenarios are canaries 
for structural problems.

(We had such a situation in the x86 code recently: we had those quirky 
x86 subarchitectures, and they were a constant source of build errors 
that no real user actually cared about - because there were no active 
users left. We modularized them into the main platform and we havent had 
a single build bug in them in the last couple of months.)

	Ingo
