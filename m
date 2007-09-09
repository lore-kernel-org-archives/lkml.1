Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbXIIVOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbXIIVOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbXIIVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:11:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33897 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148AbXIIVLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:11:51 -0400
Message-ID: <46E46190.6080607@garzik.org>
Date: Sun, 09 Sep 2007 17:11:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org>
In-Reply-To: <20070909210329.GE25798@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I can see where you're coming from, but logically, this is wrong.
>> There's a huge slew of enterprise machines that only have DVD on SATA.
> 
> ... and enterprise systems don't really care about a few KB more of code.
> In fact you definitely want to have SATA compiled in in case you need
> to recover the machine later when the SAN is down.
> 
>> On the other hand, all of these machines will have SCSI disk devices on
>> various other transports, so no harm is done, it's just an inelegant
>> solution.
> 
> Do you know of a better one?

Let's step back a moment and consider the actual scale and impact of the 
problem at hand.

The vast majority of users are consumers of pre-compiled kernels, built 
by People With Clue(tm), who figured this stuff out as soon as it was 
introduced.

The current setup expresses the dependencies as they exist -- OPTIONAL 
extras, and that is a problem once a year or so, when someone builds 
their own kernel but must learn this fact anew.

There is simply no compelling need at all to change things from the 
current setup.

Our Kconfig system is for people who already know the kernel, not Aunt 
Tillie.

	Jeff



