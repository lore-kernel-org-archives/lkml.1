Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbXLUQhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbXLUQhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXLUQhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:37:31 -0500
Received: from spirit.analogic.com ([204.178.40.4]:2031 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXLUQha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:37:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 21 Dec 2007 16:37:27.0057 (UTC) FILETIME=[C58BB010:01C843EF]
Content-class: urn:content-classes:message
Subject: Re: Trying to convert old modules to newer kernels
Date: Fri, 21 Dec 2007 11:37:21 -0500
Message-ID: <Pine.LNX.4.61.0712211136180.13826@chaos.analogic.com>
in-reply-to: <20071221143959.GG2308@csclub.uwaterloo.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Trying to convert old modules to newer kernels
thread-index: AchD78WqGC0JbZDlSQO1pEkfdadLiA==
References: <ada1w9hyrhn.fsf@cisco.com> <Pine.LNX.4.61.0712201755330.9907@chaos.analogic.com> <20071221143959.GG2308@csclub.uwaterloo.ca>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: "Roland Dreier" <rdreier@cisco.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Dec 2007, Lennart Sorensen wrote:

> On Thu, Dec 20, 2007 at 05:56:19PM -0500, linux-os (Dick Johnson) wrote:
>> Okay. Thanks! I need to do that.
>
> On the (now somewhat old) 2.6.18 kernel I use it is an option under
> "Processor type and features" called "Use register arguments", but yeah
> it isn't an option anymore in new kernels.
>
> As for your argument that it isn't a good idea, well most of the time
> the arguments you want to pass to a function are already values you were
> just working with to get them ready for the function, so quite likely
> they are already in the registers you are worried about having to clear
> first.  Add to that the ability of modern x86 CPUs to use rename
> registers to fake stack accesses in some cases and the clearing of the
> registers become pretty much a non issue, at least that's my
> understanding of how things work.
>
> --
> Len Sorensen
>

If the procedures in different files or are in libraries, there
is no way for the compiler to "know."


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
