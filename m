Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXCVHs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXCVHs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXCVHs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:48:57 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:7692 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbXCVHsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:48:55 -0400
Message-ID: <4602348E.80901@sciensis.com>
Date: Thu, 22 Mar 2007 09:47:26 +0200
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Mozilla Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
Cc: Francois Romieu <romieu@fr.zoreil.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel  
                        version 2.6.20.1)
References: <45FEB8B7.7020200@sciensis.com>    <20070320004001.GA11601@electric-eye.fr.zoreil.com>    <000601c76af9$a0ce3ce0$0864a8c0@scs1>    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>    <000e01c76b99$769cbbe0$0864a8c0@scs1>    <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>    <46012E1A.3030309@sciensis.com>    <1860.81.207.0.53.1174485549.squirrel@secure.samage.net>    <460141B4.1080109@sciensis.com>    <3079.81.207.0.53.1174489854.squirrel@secure.samage.net>    <46015442.9020008@sciensis.com> <3564.81.207.0.53.1174495003.squirrel@secure.samage.net>
In-Reply-To: <3564.81.207.0.53.1174495003.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> On Wed, March 21, 2007 16:50, Tasos Parisinos wrote:
>   
>> A malicious person may want to alter code on the detachable (and unsafe)
>> file system.
>> Lots of stuff including the kernel will be in a trapped casing (opening,
>> probing it, power
>> analyzing it, heating it etc will result in system suicide and erasure)
>>     
>
> What happens ift he whole thing is cooled so much that it stops functioning?
>
> What if the part that is supposed to do the system suicide is shot away?
>
> There are all kind of interesting ways of bypassing such protections, I
> wouldn't count on covering all of them (which doesn't mean you shouldn't try).
>
>
>   
I really can't comment more on these... you understand that in that case 
i would give away some interesting
security details... ;) But i tell you that things have evolved, i am 
even suprised to see these pieces of hardware
work against lots (i mean lots) of kinds of attacks. If you search a 
little you will find lots of hardware security
solutions on the market. Of course having the money to obtain them is 
another issue. Of course it also needs
a lot of paperwork and NDAs

>> If one alters one device then he can go on and play with it at home
>> But if one finds the key that authenticates the executable code it will
>> be possible to
>> attack and tamper the non-system software on some of the networked devices
>>
>> That is why we can't use symmetric, the risk is a lot greater there. And
>> of course
>> we cant have one key per device (maybe thousands)
>>     
>
> How many devices there are doesn't matter, a RSA key is ten times as big
> as an AES key anyway. But maybe you've a more complex system where having
> multiple keys indeed isn't possible (e.g. the filesystem is shared between
> multiple devices).
>
>
>   
it would be a mess to do desent key management

>> You are not going to check all at once but only on load. I tell you
>> again this is
>> not going to be running as a web server, but in a restricted environment
>>     
>
> Well, as the filesystem isn't restricted you should be prepared for anything.
>
> Is the RAM in restricted area or not? Because if it isn't and they have
> access to the bus then it can be tampered with.
>
>   
RAM will be restricted, we try to do the best we can on filesystem.
>> As for the code bloat and complexity... well you know its up to u to use
>> it or leave it
>> dont include where you don't need it.
>> I mean we created for our specific use, other may want to use it to
>> (maybe for
>> the same reasons, who knows) why not make it available? Isn't that what
>> open source
>> is about?
>>
>> And on the bottom line, why not have a module and functionality that Linux
>> competitors provide and advertise?
>>     
>
> I've nothing against your RSA implementation, it's one of the cleaner and
> smaller ones. Merging it is probably a good idea to stop others and to have
> a minimalistic reference implementation.
>
> I've problems with the assumed security it brings to many uses of it though.
>
> Depending on the expected lifetime of your product I'd also consider using
> something that can't be broken by quantum computers in the (near?) future. ;-)
>
> Good luck,
>
> Indan
>
>
>   
Well in our design the most HOT data will be inside chips that you need 
serious equipment (and money)
to tamper with. But these have our own OS running. Even if someone 
breaks the signed modules system he can do
damage but not to such an extent. We understand that this is not 
unbreakable (yes, no assumed super-security) ,
but we need to do it as hard as we can for others to intrude.
This is going to work as the first security-barrier.

Well with quantum, RSA will be obsolete. Also elliptic curve is now 
becoming more and more popular
But the RSA is nowadays in common use, ranging from payment systems to 
the military. It will take some years
for this to change

Thanks for your interest and usefull comments

Tasos Parisinos
-




