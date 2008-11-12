Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbYKLHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbYKLHxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 02:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYKLHxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 02:53:00 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:54160 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYKLHxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 02:53:00 -0500
Date: Wed, 12 Nov 2008 02:52:57 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: Update: "nobody cared" on Toshiba Satellite A100
In-reply-to: <490E1207.9050508@superonline.com>
X-X-Sender: lenb@localhost.localdomain
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: Stefan Assmann <sassmann@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Olaf Dabrunz <odabrunz@suse.de>, linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811120228260.3828@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <48FB3ED5.60904@superonline.com>
 <1224431722.26279.4.camel@sven.thebigcorporation.com>
 <48FB6321.7030501@superonline.com> <48FC38AE.3030007@suse.de>
 <48FD0152.60907@superonline.com> <48FDFB97.1050208@suse.de>
 <490E1207.9050508@superonline.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > 2. try the irqpoll option
> 
> I have compiled 2.6.27.4 with the spurious interrupt patch you provided,
> and I have booted it with the irqpoll option. Currently I am waiting for
> a "nobody cared" message.

When an interrupt arrives and linux finds no driver on that IRQ
willing to claim it, "irqpoll" causes Linux to search other IRQs
to find some other device driver that is looking for an interrupt.

So if the problem is that a device is provoking interrupts on the
wrong IRQ, you will not see the "nobody cared" message when
"irqpoll" is used.

> By the way, would I get any messages from the kernel if one of the IRQs
> was not handled properly and hence the functionality enabled by "irqpoll"
> was used?

No.  irqpoll is silent.

-Len

