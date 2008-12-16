Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYLPUD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYLPUD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLPUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:03:17 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57086 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYLPUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:03:16 -0500
Date: Tue, 16 Dec 2008 21:03:15 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
cc: Dave Jones <davej@redhat.com>, David Miller <davem@davemloft.net>,
       ajax@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net: Remove a noisy printk
In-Reply-To: <alpine.DEB.2.00.0812162044460.5854@blackhole.kfki.hu>
Message-ID: <alpine.LNX.1.10.0812162100370.21696@fbirervta.pbzchgretzou.qr>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com> <20081211.203243.124017657.davem@davemloft.net> <alpine.LNX.1.10.0812132310080.27276@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0812141745550.2447@blackhole.kfki.hu> <20081214200353.GA2994@redhat.com>
 <alpine.DEB.2.00.0812162044460.5854@blackhole.kfki.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-12-16 20:59, Jozsef Kadlecsik wrote:
>
>The packets in question are shorter than the IP header. How would those be 
>delivered to the host? On the LAN it might be possible to forge such 
>packets with proper HW address and be delivered. But wouldn't the network 
>card or the stack itself throw away the packets??

Yes.

>> The message is also utterly useless. What kind of action would you take
>> to a few gigabytes of "ipt_hook: happy cracking.\n" ?
>> There's no IP address logged, or any other useful information.
>
>As the packet is shorter than the IP header, what could be logged, besides 
>the fact that something worth to investigate is happening?

Find the offending process? printk current->pid.

'current' should be available in the output path,
but don't quote me on that.
