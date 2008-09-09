Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYIIS5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYIIS5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYIIS5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:57:17 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3892 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYIIS5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:57:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 09 Sep 2008 18:55:51.0620 (UTC) FILETIME=[AE17B040:01C912AD]
Content-class: urn:content-classes:message
Subject: Re: Building Kernel with -O0
Date: Tue, 9 Sep 2008 14:55:50 -0400
Message-ID: <Pine.LNX.4.61.0809091442340.5579@chaos.analogic.com>
In-Reply-To: <1220980240.17292.15.camel@CV-LAB2>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Building Kernel with -O0
Thread-Index: AckSra4hVlQ0J+H3RxGi/aPtiekaog==
References: <1220550653.15123.6.camel@CV-LAB2> <20080909160452.GB30160@cs181140183.pp.htv.fi> <1220980240.17292.15.camel@CV-LAB2>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Keith A. Prickett" <keithp@marvell.com>
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Sep 2008, Keith A. Prickett wrote:

> On Tue, 2008-09-09 at 19:04 +0300, Adrian Bunk wrote:
>> On Thu, Sep 04, 2008 at 10:50:53AM -0700, Keith A. Prickett wrote:

Microsoft and "Writing Solid Code" are mutually exclusive.

> make this work is well worth the return.  In the book "Writing Solid
> Code" (http://www.amazon.com/Writing-Solid-Code-Microsofts-Programming/dp/1556155514) one technique discussed is: stepping through your code.  In order to be able to do this effectively you need optimizations turned off.

Sorry, I couldn't resist after being required to write code in
VC++/MFC, where memory leaks are "normal," and pointers passed
to "methods" don't remain valid if there is any other activity
besides yours occurring in the machine.

If you have to single-step through kernel procedures, you
are not writing proper code for a kernel. Furthermore, even
when using the kernel debugger, you are not executing the
exact same path that would be executed without the debugger
attached.

These are some of the reasons why any attempt to compile
with no optimization will usually fall upon deaf ears. There
is a lot of in-line assembly that can't work with -O0 and if
you change the code so that it does, it will not be the same
as "normal" code so whatever it is that you are trying to
accomplish will probably fail to work as planned.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.16 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
