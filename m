Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYH0KKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYH0KKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYH0KKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:10:14 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49915 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754377AbYH0KKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:10:12 -0400
Message-ID: <48B527F6.6040705@evidence.eu.com>
Date: Wed, 27 Aug 2008 12:09:58 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: lg@denx.de, rmk+kernel@arm.linux.org.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>, marc.pignat@hevs.ch
Subject: Re: [ARM] Regression ? at91rm9200 machine-type
References: <48B3DB29.5070409@evidence.eu.com> <20080826131736.GA1916@fluff.org.uk>
In-Reply-To: <20080826131736.GA1916@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks ha scritto:
> On Tue, Aug 26, 2008 at 12:30:01PM +0200, Claudio Scordino wrote:
>> Hi,
>>
>>    I have a custom board equivalent to AT91RM9200DK.
> 
> Is that exactly the same, or does it have changes?

No, it's really equivalent, that's why I used the same configuration.

> 
> Note, this should have been sent to the linux-arm-kernel list, where
> it will be read by more of the developers who work on ARM, we don't
> all have time to sit on linux-kernel.

I see. I thought the right place for this kind of question was the
LKML. I will use linux-arm-kernel for future issues about Linux on ARM.

Anyway, eventually I found out that this is a bug of U-Boot (see
later) and not of Linux.

> 
>> After commit
>>
>> 87fee013a23ad02821699aef5b76891b42959182
>>
>> [ARM] 4647/1: at91rm9200: Remove redundant machine-type verification
>> and manipulation
>>
>> I cannot boot my board anymore.
> 
> Hmm, having looked at this, it would be very probably that your
> u-boot is not passing the right boot information to the kernel.

Right. U-Boot does not pass the right value when compiled for the
AT91RM9200DK board... I'm going to send an email to the U-Boot ML to
fix this bug.

Many thanks to all,

               Claudio



-- 
Ing. Claudio Scordino		
Software Engineer, PhD
Tel. +39-050-5492050
http://retis.sssup.it/~scordino/

Evidence Srl
Embedded Real-Time Solutions
http://www.evidence.eu.com

