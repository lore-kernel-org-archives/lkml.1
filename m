Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbYARAI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbYARAI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYARAIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:08:18 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:44465 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYARAIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:08:17 -0500
Subject: Re: [PATCH] fix wrong sized spinlock flags argument
From: Daniel Walker <dwalker@mvista.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <alpine.LFD.1.00.0801171542390.2957@woody.linux-foundation.org>
References: <20080117205205.878723737@mvista.com>
	 <alpine.LFD.1.00.0801171542390.2957@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 16:05:06 -0800
Message-Id: <1200614706.18731.170.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 15:48 -0800, Linus Torvalds wrote:
> Applied.
> 
> However, the patch itself didn't apply cleanly, because in my souce tree, 
> these two lines are in a different order:
> 
> On Thu, 17 Jan 2008, Daniel Walker wrote:
> >  
> >  	pci_set_power_state(pci_dev, PCI_D0);
> >  	pci_restore_state(pci_dev);
> 
> but I actually think your order is the *correct* one (because I'm not at 
> all sure that config space writes are even guaranteed to make a difference 
> when in D3cold).

I was actually using 2.6.24-rc8-mm1 . The code looked similar enough,
but I must have overlooked the fact that the lines above got switched..

Daniel

