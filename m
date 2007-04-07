Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXDGIgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXDGIgP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXDGIgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:36:15 -0400
Received: from mail.faust.net.ua ([195.68.202.98]:32967 "EHLO
	mail.faust.net.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965635AbXDGIgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:36:14 -0400
Message-ID: <46175942.7080707@faust.net.ua>
Date: Sat, 07 Apr 2007 11:41:38 +0300
From: Mikhail Zolotaryov <lebon@faust.net.ua>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: mporter@kernel.crashing.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPC4xx UART0 (8250) problem
References: <46171C50.3020104@faust.net.ua> <1175922756.7407.46.camel@localhost.localdomain>
In-Reply-To: <1175922756.7407.46.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote: 
> This is an old problem. The proper fix is already implemented for
> arch/powerpc and consist of having virtual irq numbers (which helps for
> many other things anyway).
> 
> Support for 4xx platforms in arch/powerpc is starting to get in, pop on
> linuxppc-dev@ozlabs.org where the patches are being posted and you are
> welcome to give a hand porting more platforms over :-)

First, thanks for response.

Ok, I see IRQ0 mapping to virtual number is good solution but I know the
problem from the times of 2.4 kernel. It was very surprising while moving to
2.6 kernel - serial driver was changed, but we have the same problem there.

Maybe it's good idea to create unofficial ppc linux branch repository
(or it already exists ?) where we can put patches that work (as above) but
not in pretty good way linux community expects.
