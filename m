Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYCDOYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYCDOYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYCDOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:24:13 -0500
Received: from spirit.analogic.com ([204.178.40.4]:1623 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYCDOYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:24:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 04 Mar 2008 14:21:31.0293 (UTC) FILETIME=[0AE65CD0:01C87E03]
Content-class: urn:content-classes:message
Subject: Re: 64-bit AMD panic
Date: Tue, 4 Mar 2008 09:21:15 -0500
Message-ID: <Pine.LNX.4.61.0803040909100.10064@chaos.analogic.com>
In-Reply-To: <9a8748490803031611m4ad2cd7dr16e30e7cb003c05f@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 64-bit AMD panic
Thread-Index: Ach+AwrvvEVw6rY1Sa+QJ8cH1JOODQ==
References: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com> <alpine.DEB.1.00.0803031942040.5974@sheep.housecafe.de> <20080303162246.3f33ee24@cuia.boston.redhat.com> <Pine.LNX.4.61.0803031704290.7011@chaos.analogic.com> <9a8748490803031611m4ad2cd7dr16e30e7cb003c05f@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Rik van Riel" <riel@redhat.com>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 3 Mar 2008, Jesper Juhl wrote:

> On 03/03/2008, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>
> <snip>
>>
>> That's the problem trying to support devices in production.
>>  The last kernel I was able to locate for the x86_64 project
>>  is linux-2.6.23. Its dates are from late last year so maybe
>>  it will work!
>>
>>  It is now being compiled one one of the target machines.
>>  If this works, I'll have to find the differences between
>>  the old and the newer and patch the linux-2.6.11 because
>>  it is a "certified" kernel, i.e., selected by the FAA and
>>  determined to be politically correct!
>
> So, you take a "certified" kernel, then you patch it, which leaves you
> with what? Certainly not a certified kernel. You might as well go with
> the latest 2.6.24.3 sources then...
>
>>
> <snip>
>>

You are preaching to the choir. When doing government things
we can't resort to logic, only "rules!" Here's an example
of why; We decide to use the latest kernel which, BTW, we are
not allowed to decide that ourselves, we would have to obtain
a consensus from lots of "interested" people, including the
people who move equipment into place (will a later kernel
weigh more? ..They need to know). The process of selecting
a new kernel could take a year. Then, it needs to be
re-certified, which could cause a few million dollars (I am
not kidding...there are people who, working out of their
YMCA rooms, charge the government $600 / hour for such
code-reviews, etc).

That's why we almost always try for a "permissive" change.
In this case, after verifying that the USB works on a
later kernel (it does), I need to find out what changes
were made to make it work and I need to incorporate those
changes into the older driver.

Adding insult to injury, I find that the driver was not
changed much, but the memory allocation scheme for bounce
buffers. To review this stuff takes a lot of nights and
weekends because nobody will give me a hint of the changes
made to make USB work. It's not in any "Changes"
documentation, but somebody knows --and they aren't
telling!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
