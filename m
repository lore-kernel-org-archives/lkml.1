Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXJCLcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXJCLcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXJCLcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:32:16 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2178 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbXJCLcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:32:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 03 Oct 2007 11:32:12.0656 (UTC) FILETIME=[0AAD9F00:01C805B1]
Content-class: urn:content-classes:message
Subject: Re: Point of gpl-only modules (flame)
Date: Wed, 3 Oct 2007 07:32:07 -0400
Message-ID: <Pine.LNX.4.61.0710030725570.19938@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0710030051350.28124@fbirervta.pbzchgretzou.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Point of gpl-only modules (flame)
Thread-Index: AcgFsQq3zgUrHbfvQ6Oni7wi9pwH0A==
References: <4702BCD0.4010202@dusted.dk> <Pine.LNX.4.64.0710030051350.28124@fbirervta.pbzchgretzou.qr>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "Jimmy" <lists@dusted.dk>, <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Oct 2007, Jan Engelhardt wrote:

>
> On Oct 2 2007 23:49, Jimmy wrote:
>>
>> Anyway, I've been trying to figure out what purpose the gpl-only code serves.
>> What good comes out of disabling people from probing modules that do not have a
>> gpl-compatible license?
>
> find /lib/modules/`uname -r` -iname '*.ko' | wc -l:
>
> 	2021
>
> Proprietary modules that I can think of:
>
> 	5 to 10
>
> It's not even 1/2 a !#$ percent. (Though knowing that many modules are for
> not-so-common hw.)
>
>> It seems pretty childish to try and force some license on people, imagine
>> trying to install firefox on Windows Vista, an error-dialog box appears:
>> "This application has been denied access to the Windows API as its license are
>> compatible with the Microsoft Philosophy" ?
>
> Not a kernel problem.
>
> (That said, MS would probably face yet another antitrust charge if it did that.
> Or better yet, people would just thankfully stop using it.)
>
>> Now, i don't want to waste clock cycles on executing code that serves no
>> purpose but restraining me from using my $1500 gfx card as intended,
>
> Perhaps you intended to buy a game console instead?
>
> That said, no one is restraining you. You can edit the kernel source
> and rip out all the GPL checks. On top, it's not like the ati or
> nvidia blob-ola would not load in today's kernel.
>
> 01:00 ichi:~ > lsmod | grep nv
> nvidia               4717076  22
>
> Oh yeah, my kernel (unpatched, btw) really tries to stop me hard
> from loading it.
>
>> so will me
>> removing that crap from the source result in somebody trying to obfuscate it to
>> a point where neither of us know what is what?
>>
>> Also, how about a list of PROS, explain to me whats so cool about it?
>>
>> - Jimmy
> -

Jimmy, a simple script can generate a link object that
will resolve any kernel symbols for your module without
any "export symbol" stuff at all. This was previously
demonstrated to the enraged few who considered it
immoral. Nevertheless, it's just as moral as bypassing
RIAA copy protection.

Just don't expect the kernel developers to authorize
its use, or show you how to do it!

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
