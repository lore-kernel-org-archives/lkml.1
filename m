Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYFQJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYFQJfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYFQJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:35:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44236 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYFQJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:35:11 -0400
Date: Tue, 17 Jun 2008 11:35:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
In-Reply-To: <20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com>
Message-ID: <alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com> <20080609125530.GF30405@parisc-linux.org> <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr>
 <20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-06-17 11:06, Maxim Shchetynin wrote:
>
>> (a) What is axonram?
>> (b) why is axonram direct_access, and my other devices (including
>> standard PC RAM) not?
>
>[Axonram is a module specific for IBM CellBlade and allows access to
>a DDR2 memory attached onto Axon controller.] You don't need
>direct_access and not azfs for main memory because there is already
>a pretty nice tmpfs for it.

So the reason azfs could be useful is...?

>> >+         Mounting such device with azfs gives memory mapped
>> >access to the + underlying memory to user space.
>> 
>> Can't I just mmap(/dev/theblockdevice), why would I need to go through 
>> azfs?
>
>Yes, you can mmap it. But what does it have to do with a file system.

Exactly, that's what I was asking myself.

>I would say you can either mmap it or place a file system on it.

The help text implies that I *need* azfs to mmap it - and that sounds
like a Rube Goldberg machine.
