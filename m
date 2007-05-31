Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbXEaWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbXEaWn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXEaWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:43:51 -0400
Received: from rtr.ca ([64.26.128.89]:4940 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbXEaWnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:43:50 -0400
Message-ID: <465F4FA2.8030200@rtr.ca>
Date: Thu, 31 May 2007 18:43:46 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>	 <465E3FF0.9010709@rtr.ca>	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>	 <465EBE20.6090803@rtr.ca>	 <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>	 <465F360D.6020603@rtr.ca> <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com> <465F4D4E.6050305@rtr.ca> <465F4E20.5080503@garzik.org>
In-Reply-To: <465F4E20.5080503@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
>> Some cards may perform better when their "memory" interface is used
>> instead of the "I/O" interface, or vice-versa.  I'm not sure which
>> of the two methods was selected by libata (probably the "memory" 
>> interface).
> 
> I am very CF-ignorant.  How does libata select a memory or I/O interface 
> on a CF device?

Right.  Usually we cannot select them, as it's the wires between
the ATA chipset (motherboard) and the CFCARD that determine this.

So I suppose this means that most implementations are using the I/O access method,
except for some embedded systems where the CFCARD is wired to the host bus
without a separate "controller" chip in between.

Cheers
