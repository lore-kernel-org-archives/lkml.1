Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623Ab0ARVB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0ARVB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520Ab0ARVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:01:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab0ARVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:01:56 -0500
Date: Mon, 18 Jan 2010 13:00:38 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100118130038.77a3adfb@nehalam>
In-Reply-To: <4B54CB0D.5070604@majjas.com>
References: <4B4E2F89.2050606@majjas.com>
	<20100113210908.GA3065@del.dom.local>
	<4B4E3834.3000609@majjas.com>
	<4B533A46.9050600@majjas.com>
	<20100117221746.GA3161@del.dom.local>
	<4B53906B.2020608@majjas.com>
	<20100117230531.GC3161@del.dom.local>
	<4B539A0A.2000504@majjas.com>
	<20100118073018.GA6270@ff.dom.local>
	<4B548C6B.10607@majjas.com>
	<20100118204658.GC3157@del.dom.local>
	<4B54CB0D.5070604@majjas.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 15:56:45 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> >> 2. The dropped tx packet (DHCP) is a bit harder to recreate, but it
> >> still happens.
> >>        

You might want to use tc filter rule to set priority of DHCP packets
higher. This would cause them to be in a separate queue and eliminate
the problem.

-- 
