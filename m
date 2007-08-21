Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbXHUUSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbXHUUSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXHUUSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:18:04 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4205 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXHUUSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:18:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 21 Aug 2007 20:17:58.0284 (UTC) FILETIME=[5D9334C0:01C7E430]
Content-class: urn:content-classes:message
Subject: Re: Software based ECC ?
Date: Tue, 21 Aug 2007 16:17:58 -0400
Message-ID: <Pine.LNX.4.61.0708211559540.4841@chaos.analogic.com>
In-Reply-To: <E1INYht-0000Xw-Ay@be1.lrz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Software based ECC ?
Thread-Index: AcfkMF2c7UotH0fZR3q86wgHNWpJFA==
References: <8QK3R-kc-9@gated-at.bofh.it> <8QSuw-4J2-9@gated-at.bofh.it> <8RoXy-3NJ-13@gated-at.bofh.it> <E1INYht-0000Xw-Ay@be1.lrz>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Bodo Eggert" <7eggert@gmx.de>
Cc: "Folkert van Heusden" <folkert@vanheusden.com>, <Valdis.Kletnieks@vt.edu>,
       "roland" <devzero@web.de>, <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Aug 2007, Bodo Eggert wrote:

> Folkert van Heusden <folkert@vanheusden.com> wrote:
>
>>>> http://pdos.csail.mit.edu/papers/softecc:ddopson-meng
> softecc_ddopson-meng.pdf
>>>> "SoftECC : A System for Software Memory Integrity Checking"
>>>
>>> Personally, I'd recommend just shelling out the bucks for hardware ECC if
>>> the reliability matters.
>>
>> a question and an idea: Q: is ecc guaranteed to detect all bitflips?
>
> It's guaranteed not to.
>
> Having n extra bits, you can detect n-bit-flips and correct n/2-bit-flips
> (provided you use an optimal code).
>
> These extra bits can flip, too, so if you have m >= 1 data bits and any
> finite number n of extra bits, it's possible to have an undetectable
> n+1-bit-flip.
> -- 
> If you can't remember, then the claymore IS pointed at you.
>
Of course common ECC codes detect and correct single bit errors.
When used in memory, bits in a word are never adjacent so a cosmic
ray or other stray particle which could upset bits usually result
in bits being upset in different words so they remain correctable.

The MIT paper is noticeably deficient in its ability to do anything
useful. It proposes checking things at 100 Hz intervals and trapping
each memory access as though these things happen only once in
awhile and, of course, assumes that the code doing the checking will
never be corrupted. Further, it ignores the cache(s).

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
