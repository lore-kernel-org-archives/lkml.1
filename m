Return-Path: <linux-kernel-owner+w=401wt.eu-S1030258AbXBGMVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258AbXBGMVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030623AbXBGMVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:21:32 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:45424 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030258AbXBGMVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:21:31 -0500
Message-ID: <45C9C3A3.1020201@aitel.hist.no>
Date: Wed, 07 Feb 2007 13:18:43 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEJIBFAC.davids@webmaster.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> The way I see this:
>> There is a copyright enforcement scheme.  (A simple test for
>> the word GPL.) Trivial, but still an enforcement scheme.
>>     
>
> If this were true, then the Linux kernel with it could not be distributed.
>
> If it were a legal mechanism to prevent people from modifying modules, then it's a further restriction. Whoever distributes a Linux kernel with a copyright enforcement scheme (assuming it includes at least one module) is violating section 6 of the GPL.
>
> Adding a copyright enforcement scheme to the kernel, and then distributing it with modules that cannot be modified in some ways because of that scheme, is imposing a "further restriction". (Since the GPL does not contain the restriction.)
>   
You _can_ modify the modules any way you wish - you just won't
be able to load one with a "GPL\0more text" version string.

This is not a "further restriction" precisely because the GPL
allow you to patch out this copyright enforcing scheme.
>> You are of course allowed to remove the test completely,
>> as the GPL lets you change the kernel source in any way you wish.
>>     
>
> It also lets you change the modules in any way you wish. I can't see how you can have it both ways. How is removing an enforcement scheme not circumventing it?
>   
Microsoft make copies of windows - how is this _not_ circumventing
the copy-protection on windows installation media? How come
movie studios are _not_ circumventing the encryption on DVDs?
How come you don't circumvent the protection system when you
install windows, typing in the key unique to your CD set?

In all cases, because they have the _keys_ to these copyright
protection systems. Using your legally obtained key is not
circumventing.  The key to the kernels copyright protection is
the source, which you can change at will.

So, I think it is possible to both have an enforceable copyright
protection system (in places that recognise such enforceability),
and also distribute under the GPL because the key to this
copyright protection system is provided. 
I don't know if a lawyer will see this the same way, but it
makes sense to me.

Similiar example - Microsoft could theoretically sell the keys to
the system protecting windows along with a licence to make copies. 
>> But you are still not allowed to circumvent the scheme as long as
>> it is in place - in those parts of the world were circumventing is
>> illegal.
>>     
Indeed, but using the provided key is not circumventing. Loading a
non-GPL module that uses GPL symbols anyway is prevented, so
forcibly loading such a module "the rootkit way" by patching /dev/mem
is a circumvention. Catch one of the script kiddies inside the US, and 
you can
theoretically nail him with the DMCA these days.

Changing the source (allowed by the GPL) is not circumvention.
Just as using your door key does not circumvent the door lock even
though you open it.  You might call this weak protection indeed,
seeing how easy it is.  Still, it means that a vendor of closed-source
modules that use GPL symbols now must distribute a kernel of
their own instead of just a module. Such rouge modules will no longer
load.  Alternatively, they can set the licence string to GPL but
then they must live up to it and provide source.
>
> If that's true, then the Linux kernel cannot be distributed in those parts of the world where circumventing is illegal. The GPL does not prohibit circumventing anything, so the DMCA (as invoked by those who added copyright enforcement schemes to the kernel) would be them imposing a further restriction on our right to modify the modules included with the kernel.
>
>   
>> So a vendor using the \0 trick is on very shaky ground. 
>> He has another option - to patch out the test.  But he
>> don't want that, for then he have to distribute a kernel,
>> not only a module.
>>     
>
> The GPL does not permit you to (ab)use the law to prevent people from modifying GPL'd works. If a law prevents people from modifying GPL'd works, then those works cannot be distributed where that law applies.
>
> You can certainly argue that this doesn't make sense if the law is not deliberately invoked. For example, some countries have a law against denying the Holocaust. I don't think you can rationally argue that no works are disrtibutable under the GPL there because someone can't legally modify those works to deny the Holocaust.
>   
The "copyright protection" stuff works the same way, I think.  You can't
deny distributing under the GPL just because someone could alter the
source so it breaks other law.  The GPL allow circumvention, it is only the
DMCA that doesn't.  Just like that holocaust law - the GPL allows
such denial too.



> But the assumption that the GPL linkage code is a copyright enforcement scheme would mean that the Linux kernel would have been deliberately modified so as to invoke a law that prevents people from modifying GPL'd works -- including the modules included with the kernel itself. If that doesn't make the kernel undistributable, the GPL clause 7 doesn't mean anything.
>   
This don't happen because it doesn't prevent distribution of GPL'd works.
The enforcement scheme don't prevent any kind of distribution.
It prevents people from _legally_ loading some non-GPL modules
(those that use GPL symbols) unless they change this part of the source.
They are allowed to make that change, but it is too much hassle for
the masses who prefer a straight binary distro kernel.

> " For example, if a patent license would not permit royalty-free redistribution of the Program by all those who receive copies directly or indirectly through you, then the only way you could satisfy both it and this License would be to refrain entirely from distribution of the Program. "
>   
It is still royalty-free.
> It seems to me that another example would be if the DMCA does not permit modification of portions of the Program, then you cannot distribute the program.
>
> This is the way the GPL's "self destruct" mechanism is supposed to work. For example, if someone claims there's a patent that prevents some piece of the Linux kernel from being used freely, the GPL is designed to force Linux developers and distributors to hack that piece out of the kernel so that the program can remain free to distribute and modify. It actually *fixes* legal problems by prohibiting distribution until the distributors can figure out how to get people's GPL rights back.
>
> The way out of the GPL problem is to make clear that it is *not* a copyright enforcement scheme, it's simply a notification scheme. Claims and actions in another direction threaten the distributability of the Linux kernel, and frankly violate the intent, spirit, and precise language of the GPL.
>   

I am not so sure that a copyright protection scheme violates even
the spirit of the GPL, as long as the keys are _always_ provided?
Because then the option of using they keys are always there,
so you can indeed make all the changes you want - and redistribute.
Which is also a reason why this scheme never will get
sophisticated - after all, it is always both legal and possible to
patch it out of the sources.

Note that this particular scheme doesn't even try to prevent copying.
It tries to protect the GPL by making it harder to erode it by
getting into a situation where 90% of the drivers necessary to
run a linux kernel are proprietary. It does so by ensuring that the
proprietary vendors access a limited API, unless they take
a lot of cumbersome extra steps like maintaining their own
"protection-free" kernel.  Which they certainly can do under
the GPL, but most prefer being compatible with distro kernels
and stock kernels.

Helge Hafting








