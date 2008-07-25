Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbYGYLMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbYGYLMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYGYLMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:12:30 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:60219 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYGYLM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:12:29 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4889B524.5010602@gmail.com>
Date: Fri, 25 Jul 2008 12:12:36 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>, hmh@hmh.eng.br,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
References: <488763AD.4050400@gmail.com> <alpine.LNX.1.10.0807250025080.11551@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807250025080.11551@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Wednesday 2008-07-23 19:00, Jonathan Cameron wrote:
>
>   
>> Dear All,
>>
>> The need for an industrialio subsystem was discussed in
>> http://lkml.org/lkml/2008/5/20/135
>>
>> Firstly thanks to all the people who have contributed to the discussion
>> of this in the past.
>>
>> In brief the intention is provide a kernel subsystem directed towards the
>> handling on sensors (and later related output devices) such as ADC's,
>> accelerometers and many others.
>>     
>
> Could this be done using UIO instead?
>   
No, this lot is directed towards devices that use serial buses such as
i2c  and SPI whereas
UIO is, from my admittedly cursory knowledge, intended for devices which
can have
their control registers memory mapped into user space.

Looks like I need to be a bit more specific in my descriptions. It's
terrible but as all the
sensors etc I work with are connected like this it never occurred to me
to make it
explicit in the description.
--
Jonathan
