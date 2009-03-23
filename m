Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZCWJE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZCWJE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZCWJES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:04:18 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:47793 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZCWJER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:04:17 -0400
Message-ID: <49C7505B.2010205@systec-electronic.com>
Date: Mon, 23 Mar 2009 10:03:23 +0100
From: =?ISO-8859-1?Q?Daniel_Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: david@lang.hm
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Schwebel <r.schwebel@pengutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Michael Olbrich <mol@pengutronix.de>,
       Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320100146.6599f671@lxorguk.ukuu.org.uk> <20090320103545.GQ5367@pengutronix.de> <20090320105556.4375176d@lxorguk.ukuu.org.uk> <20090320111552.GS5367@pengutronix.de> <49C3B33F.1020905@systec-electronic.com> <20090320153713.65bf8e2d@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0903201332130.16753@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0903201332130.16753@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm schrieb:
> On Fri, 20 Mar 2009, Alan Cox wrote:
> 
>>> information of what to copy to where comes from the object dictionary.
>>> But it is possible to extract this information from the objdict and pass
>>> it via generic structures (e.g. something like IO vectors) to the PDO
>>> module in kernel. The information flow of the configuration data is
>>> one-way only, from userspace to kernel. This is what I plan to implement
>>> in openPOWERLINK, because the copy information can also be passed to a
>>> special hardware like a DMA controller.
>>
>> Ok so your hardware in fact really is oriented around an mmap type
>> interface ?
> 
> what I understand from this thread is that the hardware is a standard 
> ethernet card.

It may be a standard Ethernet controller. But it could also be a 
controller with a special hardware acceleration.

cu,
   Daniel

--
SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Telefon  : +49 (0) 3661 6279 0
Fax      : +49 (0) 3661 6279 99
Email    : daniel.krueger@systec-electronic.com
Internet : http://www.systec-electronic.com

Managing Director   : Dipl.-Phys. Siegmar Schmidt
Commercial registry : Amtsgericht Jena, HRB 205563
