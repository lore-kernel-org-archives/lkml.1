Return-Path: <linux-kernel-owner+w=401wt.eu-S934012AbYEFWlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbYEFWlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbYEFWk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:40:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56776 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbYEFWk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:40:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Soft lockup regression from today's sched.git merge.
Date: Wed, 7 May 2008 00:41:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <20080422.015931.70144614.davem@davemloft.net> <20080422.030519.259068348.davem@davemloft.net> <1208868304.7115.251.camel@twins>
In-Reply-To: <1208868304.7115.251.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070041.02618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of April 2008, Peter Zijlstra wrote:
> On Tue, 2008-04-22 at 03:05 -0700, David Miller wrote:
> 
> > BTW, I'm also getting cpu's wedged in the group aggregate code:
> > 
> > [  121.338742] TSTATE: 0000009980001602 TPC: 000000000054ea20 TNPC: 0000000000456828 Y: 00000000    Not tainted
> > [  121.338778] TPC: <__first_cpu+0x4/0x28>
> > [  121.338791] g0: 0000000000000000 g1: 0000000000000002 g2: 0000000000000000 g3: 0000000000000002
> > [  121.338809] g4: fffff803fe9b24c0 g5: fffff8001587c000 g6: fffff803fe9d0000 g7: 00000000007b7260
> > [  121.338827] o0: 0000000000000002 o1: 00000000007b7258 o2: 0000000000000000 o3: 00000000007b7800
> > [  121.338845] o4: 0000000000845000 o5: 0000000000000400 sp: fffff803fe9d2ed1 ret_pc: 0000000000456820
> > [  121.338879] RPC: <aggregate_group_shares+0x10c/0x16c>
> > [  121.338893] l0: 0000000000000400 l1: 000000000000000d l2: 00000000000003ff l3: 0000000000000000
> > [  121.338911] l4: 0000000000000000 l5: 0000000000000000 l6: fffff803fe9d0000 l7: 0000000080009002
> > [  121.338928] i0: 0000000000801c20 i1: fffff800161ca508 i2: 00000000000001d8 i3: 0000000000000001
> > [  121.338946] i4: fffff800161d9c00 i5: 0000000000000001 i6: fffff803fe9d2f91 i7: 0000000000456904
> > [  121.338968] I7: <aggregate_get_down+0x84/0x13c>
> > 
> > I'm suspecting the deluge of cpumask changes that also went in today.
> > 
> > I guess I'll be bisecting all day tomorrow too :-/
> 
> Sadly both the cpumask changes and the group load-balancer came in the
> same batch - so its all new code. Also, it looks like the cpumask
> changes are before the load balance changes - so bisecting this will be
> 'fun'.

Can you please tell me what the current status of this is?

Rafael
