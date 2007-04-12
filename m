Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXDLIzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXDLIzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965496AbXDLIzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:55:15 -0400
Received: from mailout11.yourhostingaccount.com ([65.254.253.92]:50935 "EHLO
	mailout11.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965472AbXDLIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:55:12 -0400
X-Greylist: delayed 1287 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 04:55:11 EDT
Message-ID: <000401c77cdd$5ef79910$0864a8c0@scs1>
From: "Tasos Parisinos" <t.parisinos@sciensis.com>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>,
       <randy.dunlap@oracle.com>
References: <4610D25F.7080005@ceid.upatras.gr>    <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>    <4616BC09.2080509@tmr.com>    <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>    <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1> <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Date: Thu, 12 Apr 2007 11:34:09 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-EN-UserInfo: 6b5ac0c6b5a8f649d336ffa6ba3f3bc4:297516c839f78035fb456ced5af6b435
X-EN-AuthUser: tparisinos@sciensis.com
X-EN-OrigIP: 88.218.94.102
X-EN-OrigHost: dsl-88-218-94-102.customers.vivodi.gr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, April 11, 2007 12:14, Tasos Parisinos wrote:
>> If you are a vendor of a smart phone, a router, or worst, a point of sale
>> terminal you care about three things. The first is that the end user can't open
>> the device to probe it or alter it in a way that would create fraud. For example
>> a salesman could alter a credit card reader to see all cards as genuine and do
>> offline transactions.
> 
> I'd hope that for a smart phone and a router the owner can install whatever he wants
> (that is, he has the private key). As for the card reader, I'd hope that using a
> modified card reader isn't enough for fraud to succeed, or else the whole thing is
> designed stupid. That said, the credit card system seems insecure anyway, with readers
> being able to steal useful information.

Well with old credit cards (magnetic) it was possible (as a matter of fact it was trivial)
With new chip cards its a lot harder but still possible, only the risk is smaller in means that
the fraud will be very limited.

> Read: http://www.cl.cam.ac.uk/TechReports/UCAM-CL-TR-630.pdf
> 
> There are other similar papers. The conclusion is that if someone really wants it,
> he will get it from your device. Not sure if it was this paper or another one, but
> volatile memory can be read out after the power went off. It's even possible to
> retrieve overwritten data if it wasn't done very carefully, both RAM and flash.
> 
> If the tampering is done for a very short time, the detectors will probably miss it.
> Or the tampering is done with the one thing the device wasn't protected against.
> Or they think up some new way to bypass the protections.
> 
> Anyway, the question is what you're trying to protect. In general it's to keep the
> code hidden, because there are plenty of obscure companies that steal that expensive
> code and use it for their products. But it can also be a private key or something.
> 
> 

I didn't have time to read the pdf but i will. As for erasing ram it usually means to also 
scramble it and there are chips that advertise that can do this in 1 cycle. Well reaching the bus or ram 
to probe it is another thing. Most die in such chip are also hidden under protective meshes so it 
takes some time. What you said is true, systems are created and broken, the question is what 
you have to hide and whether the person that wants to break it has the money the will the knowledge and the equipment 
to do it. Because if he is to spend a million euro only to create fraud of half a million euro then he wont do it.
That has to do with risk management.

>> The second need is solved by authentication and encryption. The system of
>> authentication must be asymmetric because if it is symmetric and the first need
>> is not well implemented then you may get really exposed. Of course you have to
>> secure first the software that does this authentication on the device.
> 
> True. (Though asymmetric doesn't mean it has to be RSA. ;-)
> 
> 

Sure, but its just more standardized and widely used

>> So we thought, hell why not give it to others as well so we GPL'd it.
> 
> You did? We only saw a MPI implementation, nothing more. All the above mentioned
> arguments and reasoning only applies to a complete implementation, not to an
> incomplete partial solution, which on its own is useless. Don't mix up the binary
> signing thing with a nice stand alone RSA crypto module.
> 
> That said, it was nice to share the RSA code, no matter what.
> 
> 

I understand and i agree, thing is that i dont decide about which parts are given GPL.
While the RSA module is given standalone, it can be still used by others to develop
their own signing and authenticating mechanisms. For example some will decide to do 
hashing of code with md5 while others with sha1 and some will do padding compliant
with pkcs1 other will implement other schemas e.t.c. I want to say although this is not
really ready to be used for binary signing, it has the advantage to provide basic functionality
and freedom to other developers to implement their own schemas.

> But I don't see why you're so mysterious about the rest anyway, because it looks rather
> trivial to implement such binary signature checking thing. If it isn't trivial, then
> small chance it's secure...
> 
> At least I won't ever buy "secure" hardware from any vendor who's mysterious about the
> implemented protections. Because time after time it was proven that no matter how obscure
> the protection is done, it's always bypassed if it couldn't stand on its own.
> (Example: The GSM encryption used. Both reverse engineered and broken.)
> 

people think that by hiding implementations (which can be reverse engineered of course)
will make it more difficult to break. Well i agree with you but... its not in my hands.
So i will come back with these parts replaced with some of my own

And a question
Can someone provide me with a full list of kernel functions where code is loaded?

Best regards 
Tasos Parisinos

