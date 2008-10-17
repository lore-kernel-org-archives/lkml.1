Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYJQMOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYJQMOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYJQMOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:14:11 -0400
Received: from mail.us.es ([193.147.175.20]:33876 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753061AbYJQMOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:14:09 -0400
Message-ID: <48F883D4.8050809@netfilter.org>
Date: Fri, 17 Oct 2008 14:23:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20081015.163817.193700221.davem@davemloft.net> <20081017082138.GA23155@elte.hu> <48F87D3E.5020007@trash.net> <20081017120408.GA20030@elte.hu>
In-Reply-To: <20081017120408.GA20030@elte.hu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Patrick McHardy <kaber@trash.net> wrote:
> 
>>> net/netfilter/nf_conntrack_netlink.c:819: warning: ‘enum nf_nat_manip_type’ declared inside parameter list
>>> net/netfilter/nf_conntrack_netlink.c:819: warning: its scope is only this definition or declaration, which is probably not what you want
>>> net/netfilter/nf_conntrack_netlink.c:818: error: parameter 2 (‘manip’) has incomplete type
>> Thanks Ingo. I just sent this patch to Benjamin Herrenschmidt
>> for testing.
> 
> build still fails with the attached config.

We have to wrap ctnetlink_parse_nat_setup with CONFIG_NF_NAT_NEEDED, 
I'll send you a patch asap. Sorry for the breakage.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
