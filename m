Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXBLPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXBLPxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXBLPxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:53:18 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:56497 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933017AbXBLPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:53:17 -0500
Message-ID: <45D08CC0.30403@aitel.hist.no>
Date: Mon, 12 Feb 2007 16:50:24 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <MDEHLPKNGKAHNMBLJOLKKEAGBHAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEAGBHAC.davids@webmaster.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> Indeed, but using the provided key is not circumventing. Loading a
>> non-GPL module that uses GPL symbols anyway is prevented, so
>> forcibly loading such a module "the rootkit way" by patching /dev/mem
>> is a circumvention. Catch one of the script kiddies inside the US, and 
>> you can
>> theoretically nail him with the DMCA these days.
>>     
>
> The greater has to include the lesser. If you have the authority to remove or modify a copyright enforcement scheme, you cannot be circumventing it.
>   
I have a key to my office door that I am authorized to use.
That don't mean it is ok for me to circumvent the lock with a crowbar too.

> In any event, if your argument were correct, the Linux kernel would not be distributable. The license enforcement scheme in the kernel makes it unlawful to modify the modules in a particular way, and they are both distributed under the GPL. This would be a "further restriction" since the restriction is not found in the GPL itself.
>   
No, it is not a licence restriction.  It is a law.  Modifying the
kernel to send holocaust-denying messages (or other illegal
stuff like printing money) is illegal too, but not an
additional restriction. 

The copyright protection scheme does _not_ change the licence,
and the licence lets you remove it. So - no problem with the GPL.
The law says "don't circumvent", so you can't hack /dev/mem
to forcibly load a strange module.  This is not a restriction
on (re)distribution of the kernel - but on the running.  And it
is a law, not an additional clause in the licence.

>> Changing the source (allowed by the GPL) is not circumvention.
>>     
>
> Then you can change the module source to include a null in the license tag.
>   
Yes.  And then the distro kernels will refuse to load it, which is the
whole point.  Sure - it is possible to get around this (in a legal way)
by distributing an altered kernel.  But that is troublesome extra work for
module vendors who want to do such tricks.  They can do it
because of the GPL, but they won't enjoy it.  They just want to
distribute their driver.  Their binary driver will become less popular if it
forces users to recompile the kernel - and especially if the patch
collides with patches for every other closed-source driver that
try to use the same trick.

So yes - they can get around the enforcement system, but they
won't enjoy it.  They won't enjoy being incompatible with distro kernels.


>   
>> Just as using your door key does not circumvent the door lock even
>> though you open it.
>>     
>
> And neither is breaking down your own door. If you have the right to remove the door, you have the right to break it down. The greater includes the lesser.
>   
Nope.  I am authorized to open and enter many doors that I don't own.
I have no right to open them by other means, just as I have
no right to relicence the linux kernel even if I may modify & 
redistribute it.

>> You might call this weak protection indeed,
>> seeing how easy it is.  Still, it means that a vendor of closed-source
>> modules that use GPL symbols now must distribute a kernel of
>> their own instead of just a module. Such rouge modules will no longer
>> load.  Alternatively, they can set the licence string to GPL but
>> then they must live up to it and provide source.
>>     
>
> Sounds like a further restriction to me. This is a restriction on how the modules can be modified, it's not found in the GPL, and it was imposed by people who modified the kernel. This is exactly what the GPL was designed to force people to remove before they could distribute a work.
>   
It is not about modifying the modules - the vendor already released
the module under a non-gpl licence.  (If it is gpl - no problem)

It is about the kernel.  The _can_ modify the kernel, but it'd be
more work! 

Are you talking about modifying the running kernel through
loading a module via /dev/mem hacking? 
The GPL does of course not prevent that either, but
the DMCA might.  Even if it doesn't - people relying on this
will see no end of breakage as this  "interface"  surely won't
be preserved.  Somehow, I think it will be actively broken
in every release if closed-source vendors try to go down this path.

>> The "copyright protection" stuff works the same way, I think.  You can't
>> deny distributing under the GPL just because someone could alter the
>> source so it breaks other law.  The GPL allow circumvention, it 
>> is only the
>> DMCA that doesn't.  Just like that holocaust law - the GPL allows
>> such denial too.
>>     
>
> Right, but you can't put something into your source such that someone removing it or modifying it is breaking the law. 
Then the kernel is undistributable and has always been.  The kernel
prints it version string as it boots up, it is easy enough to add
illegal stuff to that.  Holocaust denail, slander, state secrets, . . .
So someone can indeed modify the kernel and ending up breaking the law.
Does it matter whether they break the DMCA or another law?

> If there was a law that said a file could not be modified if someone put the words "DO NOT MODIFY" in it, then you could *not* put such words in a GPL'd work. If you did, such a work would not be distributable because the law imposes a further restriction.
>
> The DMCA is no different. It's a law that says if you put a copyright enforcement scheme in a work, then someone can't circumvent it. Since there are no anti-circumvention rules in the GPL itself, it's a further restriction.
>
> Simply put, if you assume this is a license enforcement scheme, then the Linux kernel together with some modules contains a further restriction that prohibits you from modifying the modules in ways allowed by the GPL. This is precisely what the GPL prohibits.
>
>   
>> " For example, if a patent license would not permit 
>> royalty-free redistribution of the Program by all those who 
>> receive copies directly or indirectly through you, then the only 
>> way you could satisfy both it and this License would be to 
>> refrain entirely from distribution of the Program. "
>>     
>
>   
>> It is still royalty-free.
>>     
>
> You are missing the point of the example. This is an example of what happens when some kind of legal process not found in the GPL operates to restrict the rights guaranteed by the GPL.
>
>   
>> I am not so sure that a copyright protection scheme violates even
>> the spirit of the GPL, as long as the keys are _always_ provided?
>> Because then the option of using they keys are always there,
>> so you can indeed make all the changes you want - and redistribute.
>> Which is also a reason why this scheme never will get
>> sophisticated - after all, it is always both legal and possible to
>> patch it out of the sources.
>>     
>
> I cannot see any rational way you can have the right to modify all the involved code, the right to remove the scheme, and yet you can be "circumventing" it.
>
>   
>> Note that this particular scheme doesn't even try to prevent copying.
>>     
>
> That's simply not true. It makes some proprietary modules unusable on mainstream kernels, thus decreasing the value of them if they're distributed. This is exactly what many anti-copying schemes do.
>   
Copying is only "prevented" by reducing the incentive.  Any copies
made & distributed are still legal copies.  Not so with a copy of a DVD.
The value of the modules might decrease because they are useless, but
that is ok.  The modules wasn't GPLed anyway - only the kernel.

> How is this scheme (which makes mainstream kernels unable to work with modules that are not GPL-licensed) different from the DVD scheme (that makes unlicensed players unable to play mainstream DVDs)? Engineered incompatability restricts the distribution value of the items made incompatible.
>   
There is the difference that copying the DVD is illegal anyway - it doesn't
matter if you bypass copy-protection or not.  (You can trivially copy
a DVD without breaking the encryption - you can then sell
it on the black market to people who have working DVD players.)

You can legally copy the kernel though.  Or modify it.
Removing the copyright enforcing with a patch is perfectly ok.
A vendor doing this will have the added work if supporting that patch 
though.
Defeating the protection while it is up and running is what might
be illegal.  It is unusual that you are actually allowed to remove the
scheme by a patch.  I assume this don't change how the DMCA works,
bit of course this will depend on the exact wording.
Using your provided key is not circumventing - smashing the lock is.

What if you buy a copy of windows, then binary patch the install DVD
so it don't ask for the registration code, then install it on your own
PC (without redistributing the cracked DVD?)
The end result is no different from a normal install, you paid for the 
software,
you didn't circulate any cracks.  You just prefer this way of installing
rather than typing in lots of numbers from a piece of paper. Perhaps
it really is easier - with some highly automated cracking software.

It is legal here where the DMCA doesn't apply - How about the U.S.?

>> It tries to protect the GPL by making it harder to erode it by
>> getting into a situation where 90% of the drivers necessary to
>> run a linux kernel are proprietary.
>>     
>
> If you choose the GPL, you lose the right to "make it harder" for people to distribute and modify code. The GPL sets the terms and is carefully constructed so that nobody can later change them.
>   
And this scheme doesn't make it harder to distribute and modify
kernel code.  It might make it harder to get a closed-source
module working, or to make it work without the GPL symbols
it really would like to use.

Many changes in the kernel makes it harder to make things work,
the kernel is getting bigger and more complicated all the time.
"Hardness" can't possibly matter.  A more complicated (but also
more efficient) VM makes it harder to make a useful patch. Only
the useless ones are as easy as always.

>> It does so by ensuring that the
>> proprietary vendors access a limited API, unless they take
>> a lot of cumbersome extra steps like maintaining their own
>> "protection-free" kernel.  Which they certainly can do under
>> the GPL, but most prefer being compatible with distro kernels
>> and stock kernels.
>>     
>
> This is precisely the type of thing the GPL was designed to prohibit. You are not supposed to be able to abuse copyright to retain control over a GPL'd work.
>   
I always had the impression that the GPL was made to prevent
closed distribution of something that started out free.  So you
can't add non-gpl stuff into the kernel, or distribute
binary while holding back source.

This copyright enforcement scheme don't prevent any of that,
precisely because it can be removed from the _source_ legally.
Tampering with it while it runs might be illegal some places,
just as printing certain strings might be illegal.

Closed modules are allowed only because an exception was made
in the licencing.  That didn't have to happen at all.  Closed modules
only get a limited interface, so that they won't be derived works.
Circumventing that creates a non-GPL derived work - which is illegal
to redistribute regardless of protection schemes. 
The sceme just makes this harder
to do for those who wish to try anyway.  The DMCA might be
useable for making it even harder.  An interesting irony - turning the
DMCA against the sort of people who wanted it in the first place.

DMCA or not - copyrigth law prevents distributing a closed derived work.
Unfortunately, that don't stop people from trying - it is hard to
see what's going on in a closed module.  Now if breaking the law
this way can be made more difficult then that is a good thing.  Fewer
vendors will then try.  They will make closed modules hampered by
no access to GPL symbols - or open-source modules, or none at all.

Helge Hafting




