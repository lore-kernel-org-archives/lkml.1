Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYJQAn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYJQAn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYJQAnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:43:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:47079 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYJQAnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:43:18 -0400
Subject: Re: [git pull] core kernel updates for v2.6.28
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <becky.bruce@freescale.com>
In-Reply-To: <1224204023.7654.43.camel@pasglop>
References: <20081015125023.GA6702@elte.hu>
	 <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
	 <1224204023.7654.43.camel@pasglop>
Content-Type: text/plain; charset=utf-8
Date: Fri, 17 Oct 2008 11:41:31 +1100
Message-Id: <1224204091.7654.45.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 11:40 +1100, Benjamin Herrenschmidt wrote:
> Ok, so I didn't spot a problem with your hand-merge of the phys_addr_t
> stuff, but that was a quick look, I'll let Becky test the FSL
> platforms . However, one of my test configs broke with:

Argh.. sent too fast :-) So I said, it broke with:

/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:819: warning: ‘enum nf_nat_manip_type’ declared inside parameter list
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:819: warning: its scope is only this definition or declaration, which is probably not what you want
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:818: error: parameter 2 (‘manip’) has incomplete type
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c: In function ‘ctnetlink_parse_nat_setup’:
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:821: error: ‘nfnetlink_parse_nat_setup_hook’ undeclared (first use in this function)
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:821: error: (Each undeclared identifier is reported only once
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:821: error: for each function it appears in.)
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:821: warning: type defaults to ‘int’ in declaration of ‘parse_nat_setup’
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:823: warning: type defaults to ‘int’ in declaration of ‘_________p1’
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:823: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/benh/kernels/linux-powerpc/net/netfilter/nf_conntrack_netlink.c:841: error: called object ‘parse_nat_setup’ is not a function

Cheers,
Ben.


