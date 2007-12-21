Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXLUQj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXLUQj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXLUQjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:39:49 -0500
Received: from spirit.analogic.com ([204.178.40.4]:4452 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXLUQjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:39:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 21 Dec 2007 16:39:37.0017 (UTC) FILETIME=[13020290:01C843F0]
Content-class: urn:content-classes:message
Subject: Re: Trying to convert old modules to newer kernels
Date: Fri, 21 Dec 2007 11:39:36 -0500
Message-ID: <Pine.LNX.4.61.0712211137490.13826@chaos.analogic.com>
in-reply-to: <20071221144319.GH2308@csclub.uwaterloo.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Trying to convert old modules to newer kernels
thread-index: AchD8BMLHGpwpEMhQNCFWDvTMjOYMg==
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com> <20071220182815.GA5438@uranus.ravnborg.org> <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com> <20071221144319.GH2308@csclub.uwaterloo.ca>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Dec 2007, Lennart Sorensen wrote:

> On Thu, Dec 20, 2007 at 04:27:37PM -0500, linux-os (Dick Johnson) wrote:
>> I need to get rid of -mregparm=3 on gcc's command line. It
>> is completely incompatible with the standard calling conventions
>> used in all our assembly-language files in our drivers. We make
>> very high-speed number-crunching drivers that munge high-speed
>> data into images. We need to do that in assembly as we have
>> always done.
>
> Well I guess you can either fix the assembly once and for all to handle
> the current linux way of doing things, or you can patch to kernel back
> to the old ways of doing things when using your driver.
>
> I suppose you could just add some wrapper functions to your assembly
> that uses the new regparm calling method and then calls your methods the
> old way and selectively enable those when regparm is used by the kernel
> if you want to support all kernel versions.  Or you could use inline
> assembly in C functions to handle the calling convention for you.
>
> --
> Len Sorensen
>

It's easier that that, just declare the assembly-language
functions to be of type __attribute((regparm=0))__ or however
you spell it (I'm not at my usual machine)!



Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
