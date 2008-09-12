Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYILNZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYILNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYILNZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:25:18 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4910 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYILNZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:25:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 12 Sep 2008 13:23:17.0766 (UTC) FILETIME=[B7E87260:01C914DA]
Content-class: urn:content-classes:message
Subject: Re: Building Kernel with -O0
Date: Fri, 12 Sep 2008 09:23:16 -0400
Message-ID: <Pine.LNX.4.61.0809120918570.7332@chaos.analogic.com>
In-Reply-To: <2cf1ee820809112221w213aa929x32905e1c25897cf3@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Building Kernel with -O0
Thread-Index: AckU2rfvfd7xhN3QTFm8I8zZoknvsQ==
References: <b8rB2-6BM-1@gated-at.bofh.it> <badXc-7gl-21@gated-at.bofh.it> <baf2M-bE-7@gated-at.bofh.it> <bagBJ-20J-7@gated-at.bofh.it> <E1KdOFZ-0001Q4-So@be1.7eggert.dyndns.org> <2cf1ee820809112221w213aa929x32905e1c25897cf3@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "emin ak" <eminak71@gmail.com>
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>, <7eggert@gmx.de>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Sep 2008, emin ak wrote:

> 2008/9/10 Bodo Eggert <7eggert@gmx.de>:
>> linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>
>>> If you have to single-step through kernel procedures, you
>>> are not writing proper code for a kernel. Furthermore, even
>>> when using the kernel debugger, you are not executing the
>>> exact same path that would be executed without the debugger
>>> attached.
>>
>> I sometimes single-step in order to verify my (userspace) code, instead of
>> just throwing random test data at it. It's easier and makes me feel better.
>> OTOH, -O2 never was a problem if I used it, so I don't strongly vote
>> for enabling -O0.
>>
>> --
>
> I had compiled linux-2.6.23 with -O0 for kgdb only with little
> modifications, it's  running with no error for a long time. I'am not a
> linux expert, I think talented kernel hackers can make kernel to
> compile with -O0 easly but for some reason they dont want to do it.
> Debug is much understandable for me (and for most people I think) with
> -O0. Linux kernel programming ability is not a gift, of course you can
> learn the code with printks and reading, but which age are we living
> in?
>
> Emin
>

Well, to use the ** kernel ** to single-
step through the ** kernel ** is
really not going to be much more than an
exercise. It's not going to find the bugs
that are likely to exist in kernel code.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.38 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
