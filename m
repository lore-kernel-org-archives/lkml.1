Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbXEVQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbXEVQfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbXEVQfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:35:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52991 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758993AbXEVQfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:35:24 -0400
Message-ID: <46531BC7.9090608@garzik.org>
Date: Tue, 22 May 2007 12:35:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <200705220846.53664.jbarnes@virtuousgeek.org>	 <9e4733910705220902y151d1922s7e478de041062aa4@mail.gmail.com>	 <200705220915.50238.jbarnes@virtuousgeek.org> <9e4733910705220932x43e0e31bn39f7eb9223f3557e@mail.gmail.com>
In-Reply-To: <9e4733910705220932x43e0e31bn39f7eb9223f3557e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:
> On 5/22/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Tuesday, May 22, 2007, Jon Smirl wrote:
>> > I've talked to an ATI engineer about VBIOS initialization. The chips
>> > may have different steppings. They flash the right VBIOS that matches
>> > the chip into the ROM on the card.  Given all the various steppings
>> > this is the only sane way to initialize the hardware. I don't believe
>> > generic initialization code that can handle all of the various
>> > steppings exists for any hardware.
>>
>> I think you must have misunderstood.  Last time I worked on ATI, there 
>> was
>> a single ROM image that supported several (maybe even all) of their addin
>> cards.  There's nothing magical about them...  But that's beside the
>> point.
> 
> What about the poke the obscure value into this undocumented IO port
> class of problem where they are using the chip test interface to work
> around bugs in the silicon.
> 
> He also mentioned that all of the OEMs change the standard ROM image
> before loading it onto their cards to handle how they wired things up
> and bugs in other chips.
> 
> Of course I don't have the source for the ROM so I don't know the
> accuracy of what I was told.

There is nothing magic about a ROM.  It's just software, or, often, data 
tables.

	Jeff



