Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXGZQW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXGZQW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760733AbXGZQWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:22:19 -0400
Received: from homer.mvista.com ([63.81.120.155]:35454 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758432AbXGZQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:22:18 -0400
Message-ID: <46A8CAB2.5050706@ru.mvista.com>
Date: Thu, 26 Jul 2007 20:24:18 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
References: <20070725165318.5331.23795.stgit@localhost.localdomain>	<20070725165326.5331.19920.stgit@localhost.localdomain>	<46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com>	<20070725180145.GA29689@ld0162-tx32.am.freescale.net>	<46A7941F.2050300@ru.mvista.com> <46A798D8.7020906@freescale.com> <46A7A4EC.2020503@ru.mvista.com>
In-Reply-To: <46A7A4EC.2020503@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>>   Also, what mmio-ide in the compat properly means in the context 
>>>>>of ide_platform which is able to handle both port and memory mapped 
>>>>>IDE.

>>>>I/O-space is only valid in the context of PCI, ISA, or similar buses, 
>>>>and
>>>>the bus-specific reg format indicates whether it's mmio-space or
>>>>io-space.

>>>   You could save time on lecturing me (and use it to look on the 
>>>driver ;-).

>>Sorry, I misread the question as being a mismatch between the 
>>capabilities of the device binding and the driver, not about the 
>>specific compatible name.

>     That too. :-)

>>Something like "generic-ide" would probably be better.

>     I strongly disagree with "generic" part. The generic IDE could only be 
> said of 1:1 I/O mapped IDE ports, not about this fancy mapping.

    BTW, there's already something called drivers/ide/ide-generic.c... :-)

MBR, Sergei

