Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbXGVMTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbXGVMTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbXGVMT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:19:27 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:4717 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556AbXGVMT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XvczzuHkCcvT0ms5U8XV3yrYDzqDi2byGFK0kSOBUuWSgzA2Ps+9MIeh4Ej2y/46hBDvUsiBJYKEbs+Fr7j4f+kwjZFshvktVjEjWwK7cZ5wMZ0ddNO9R46BOJY05xNeT38IQEm+sjDrVpeD2l3WnO6w/XlHakHwOz6cl94nAqs=
Message-ID: <46A34B46.6050204@gmail.com>
Date: Sun, 22 Jul 2007 21:19:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?UTF-8?B?UsO6YmVuIEZvbnNlY2E=?= <krani1@0x82.com>
CC: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata [ata_piix] still no resume from S3 ?
References: <20070712162450.GA7132@0x82.com> <469744DB.5070600@gmail.com>	 <20070714210117.GA20723@0x82.com> <469DD216.5040305@gmail.com>	 <20070719092053.GA21254@0x82.com> <469F2E4A.1020502@gmail.com>	 <20070719150436.GA9006@0x82.com>  <46A0552E.30606@gmail.com> <1185017817.7774.6.camel@0x82>
In-Reply-To: <1185017817.7774.6.camel@0x82>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rúben Fonseca wrote:
> On Fri, 2007-07-20 at 15:24 +0900, Tejun Heo wrote:
>> Rúben Fonseca wrote:
>>> I wish I could disable this card reader. It is built in on the hardware,
>>> and there are no drivers for Linux. There is no option on the BIOS to
>>> disable the device. Is there any way (kernel parameters, magic program,
>>> etc) to disable this device without opening my laptop to cut the wires?
>>> :D
>> OIC.  How about not loading tifm_7xx1 module?  Does that make any
>> difference?
>>
> 
> AFAIK the tifm_7xx1 module belongs to the other card reader I have on
> this laptop (see device ID 09.04.0). This one is a cardbus device and I
> can simply disconnect it on startup, and the tifm_7xx1 modulo is never
> loaded. Anyway I've tried without this card and module and it still
> doesn't work.

Can you post the failing log (just take a picture of the screen) with
the card reader disconnected?

-- 
tejun
