Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbZE0Tq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbZE0Tq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbZE0TqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:46:20 -0400
Received: from h155.mvista.com ([63.81.120.155]:63092 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756806AbZE0TqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:46:19 -0400
Message-ID: <4A1D98C9.9030908@ru.mvista.com>
Date: Wed, 27 May 2009 23:47:21 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Scott Wood <scottwood@freescale.com>, Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb>	<fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>	<20090527150527.GK6805@pengutronix.de>	<87vdnm8sec.fsf@macbook.be.48ers.dk>	<4A1D6901.2090508@freescale.com>	<20090527175609.GB31861@flint.arm.linux.org.uk>	<4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk>
In-Reply-To: <20090527192909.GA32398@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Russell King wrote:

>>>smc91x is a prime example of the kind of information drivers need - base
>>>address and irq are very much insufficient to describe how this device is
>>>connected.  There's much more information required to specify this device
>>>fully, and throwing it into the driver doesn't work.  We've been there
>>>and proven that point.

>>The device tree is quite capable of expressing information beyond  
>>addresses and interrupts.

> Bus width?  Register offset spacing?  SMC LED configuration?  Whether
> to use the hardware wait signal from the SMC?

    Yes, it's perefectly capable of all that. In fact, the first two items 
have already been defined for MTD and serial devices (though I wasn't happy 
about how the 2nd item was done IIRC).

> If you're going to say yes to all that, I'm going to start asking how
> you cope with verifying that the data for ethernet driver A doesn't
> get accidentally used for ethernet driver B.

    It's incorporated into the device node corresponding to Ethernet device 
A, which driver B doesn't drive.

> I assume you have some kind of compiler, which needs a set of specification
> files to tell it what's required for each driver which is OF compatible.

    The compiler is called (surprise :-) 'dtc'.

> If not, I can see no way for OF trees to ever be safe and correct.

WBR, Sergei
