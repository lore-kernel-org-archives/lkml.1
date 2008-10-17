Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYJQN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYJQN3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYJQN25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:28:57 -0400
Received: from stinky.trash.net ([213.144.137.162]:65056 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbYJQN24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:28:56 -0400
Message-ID: <48F89311.6090208@trash.net>
Date: Fri, 17 Oct 2008 15:28:49 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT]: Networking
References: <20081015.163817.193700221.davem@davemloft.net> <20081017082138.GA23155@elte.hu> <48F87D3E.5020007@trash.net> <20081017120408.GA20030@elte.hu> <48F88660.7080204@netfilter.org>
In-Reply-To: <48F88660.7080204@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pablo Neira Ayuso wrote:
> Ingo Molnar wrote:
>> * Patrick McHardy <kaber@trash.net> wrote:
>>
>>>> net/netfilter/nf_conntrack_netlink.c:819: warning: ‘enum 
>>>> nf_nat_manip_type’ declared inside parameter list
>>>> net/netfilter/nf_conntrack_netlink.c:819: warning: its scope is only 
>>>> this definition or declaration, which is probably not what you want
>>>> net/netfilter/nf_conntrack_netlink.c:818: error: parameter 2 
>>>> (‘manip’) has incomplete type
>>> Thanks Ingo. I just sent this patch to Benjamin Herrenschmidt
>>> for testing.
>>
>> build still fails with the attached config.
> 
> This should fix it. I have slightly tested it here with your config.
>

Applied, thanks Pablo.

I'll look into cleaning up those conditional includes. Its getting
more and more complicated to even build-test all the combinations.

