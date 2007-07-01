Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbXGAAFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbXGAAFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 20:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbXGAAFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 20:05:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:26219 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbXGAAFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 20:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Ad92osZFKiFl3w9RTbwZtOeDw5vHoc8HwNc8Z1K0ZFuqMrfAcPqvcBLFKgKi/4lCbVpMEPuexxHWpZz1DhxXRWgL9y/DYEp2b0bh22ugHs6CPCbKrBhvid1jYMYwJ5Jrac1OWiUhPvAIiBZPqzTrJLmWXVbjv76S50r6ZFHfv7s=
Message-ID: <4686EF8D.1020405@googlemail.com>
Date: Sun, 01 Jul 2007 02:04:29 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc
 does not find chip
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706191731.24085.bjorn.helgaas@hp.com> <200706272156.05865.bjorn.helgaas@hp.com> <200706292041.31291.bjorn.helgaas@hp.com> <4686EEE8.4010806@googlemail.com>
In-Reply-To: <4686EEE8.4010806@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski pisze:
> Hi,
> 
> Bjorn Helgaas pisze:
>> [patch] PNP SMCf010 quirk: work around Toshiba Portege 4000 ACPI issues
>>
>> When we enable the SMCf010 IR device, the Toshiba Portege 4000 BIOS claims
>> the device is working, but it really isn't configured correctly.  The BIOS
>> *will* configure it, but only if we call _SRS after (1) reversing the order
>> of the SIR and FIR I/O port regions and (2) changing the IRQ from active-high
>> to active-low.
>>
>> This patch fixes the 2.6.22 regression:
>>     "no irda0 interface (2.6.21 was OK), smsc does not find chip"
> 
> Hmmm...
> 
> 375  	2007-06-29 14:24:47  	6921  	 	mkkp  	"no irda0 interface (2.6.21 was OK), smsc does not find chip" fixed, STATISTICS Bjorn Helgaas +1
> 
> Wasn't it fixed?
> 
> commit 172d0496cd22c98ee2e4238821fa309c01685f3a
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Wed Jun 27 14:09:52 2007 -0700
> [..]
>     This patch addresses part of the 2.6.22 regression:
                           ^^^^
                           yup, my fault.


Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
