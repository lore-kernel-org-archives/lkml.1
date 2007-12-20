Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXLTV1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXLTV1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbXLTV1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:27:12 -0500
Received: from spirit.analogic.com ([204.178.40.4]:2055 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXLTV1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:27:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 20 Dec 2007 21:23:13.0388 (UTC) FILETIME=[87246AC0:01C8434E]
Content-class: urn:content-classes:message
Subject: Re: Trying to convert old modules to newer kernels
Date: Thu, 20 Dec 2007 16:23:12 -0500
Message-ID: <Pine.LNX.4.61.0712201615580.9531@chaos.analogic.com>
in-reply-to: <20071220162700.GF2308@csclub.uwaterloo.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Trying to convert old modules to newer kernels
thread-index: AchDTocuQUJcZly6TdOk3hrwEE6k9w==
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com> <20071220162700.GF2308@csclub.uwaterloo.ca>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Dec 2007, Lennart Sorensen wrote:

> On Thu, Dec 20, 2007 at 11:13:19AM -0500, linux-os (Dick Johnson) wrote:
>> It never gets to the printk(). You were right about the
>> compilation. Somebody changed the kernel to compile with
>> parameter passing in REGISTERS! This means that EVERYTHING
>> needs to be compiled the same way, 'C' calling conventions
>> were not good enough!
>>
>> FYI, it has been previously shown that passing parameters
>> in registers on register-starved ix86 machines is always
>> a loss, because the registers need to be freed up, either
>> by saving them on the stack or as dummy memory variables.
>>
>> Now, they've done it to the entire kernel!
>
> It's a config option.  I think redhat was the first to actually start
> using it on their distributions.  Many distributions don't use it.
> Debian does not use it on their kernels.
>
> --
> Len Sorensen
> --

It doesn't seem to be something in .config. Do you know how to
reconfigure to get parameter passing put back like it was? Our
production applications have lots of assembly-language files
and I'm sure we are not going to be able to change all those!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
