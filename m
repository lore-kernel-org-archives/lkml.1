Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZGHMEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZGHMEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZGHMEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:04:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35890 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788AbZGHMEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:04:14 -0400
Date: Wed, 8 Jul 2009 13:02:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090708130256.40957c3f@lxorguk.ukuu.org.uk>
In-Reply-To: <19028.31088.400461.939917@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<19028.31088.400461.939917@samba.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I find it rather ironic that you are advocating leaving the Linux
> kernel open to further legal attacks by Microsoft because if we didn't

Now you are being totally inconsistent.

Either leaving the code in the source is not a problem, _or_ if it could
be a problem (for US citizens) then vendors will need to remove the code
from their tree completely.

> we've been round this loop before. See my previous emails where I
> explained why I think having it upstream is an advantage. See also the
> reply from James.

James reply was based on the fallacy that vendors will keep the source in
their tree. They don't do that *today*, look at their trees.

>  > this patch set, and saying they would enable it. Not one voice seems to
>  > have appeared.
> 
> I never claimed to represent any vendors. I said that it was my
> opinion that many vendors will want to apply this patch, and you seem

So why have the vendors not commented on list ? If they will want to
apply the patch why don't I see supporting email from them ?

>  > At that point nobody managing risk is going to do anything but remove the
>  > code that worries them. It's additional risk with no return.
> 
> Some vendors may well do that. Some may decide to keep it as a compile
> time option. The legal advice that I've seen is that keeping it as a
> compile time option is fine. 

I can't comment on the advice I've seen directly, but I will point out
that every vendor I am aware of *removes completely* any source material
which they view with concern. You can download the packages and review
them if you doubt it.

> If it's pulled out of kernel.org trees then:
> 
>  - each vendor may end up with slightly different varients. That means
>    we could have Linux devices behaving inconsistently.

The Linux Foundation can manage a reference patch if it wants, or someone
can set up "Linux-USA" or similar git trees on top of the real kernel
one. Git is actually rather good at that.

>  - the testing and discussion may end up happening in a less open
>    manner. I think the testing and discussion on lkml has been very

Less open than "I'm sorry our lawyer says we can't use a non colliding
entry but we can't tell you why", plus of course to one person a "we will
tell you off list", which I understand they haven't.

>    valuable. As you've noted, vendors have not been actively
>    participating in these discussions. Do you think they'll suddenly
>    decide to start discussing things openly if we move it out of a
>    kernel.org tree? You must know how reluctant vendors are to draw
>    attention to themselves when it comes to patents.

I don't actually think they will participate either way - so this
argument of yours doesn't hold water either.

>  - some vendors may decide not to use Linux, and switch to embedded
>    windows instead if we don't have a clearly supported way of
>    avoiding these patents in the Linux kernels.

That is a business problem not a technical one. The people who keep the
out of tree patch need to share and discuss what they are doing. They
need to do that in a framework which allows them to do it right. That
means the Linux Foundation or similar with a lawyer present is the
nearest they can do to "open" any way.

>  - we'd be setting up the kernel to have a deliberate long term
>    difference between what a large part of the user base runs and what
>    is tested for kernel.org kernels. As I said previously, I think

That has always been the case. That is the established practice for all
packages in the open source world today. The kernel is not different. If
you put in special American treatment you need to do the same for Chinese
compliance (No reference to Taiwan as a country or implication thereof in
code page naming etc) and every other country in the world.

It's also an incredibly complicated specialist field. The vendors have
teams of experts working on it who deal with everything. Dumping that on
the community is neither appropriate nor fair. You want to sell Linux
products in the USA, you do the compliance work. Given that deciding what
do about FAT is a tiny spec of the vast red tape you must complete (from
crypto exports to liability insurance) its no real overhead to the vendor.

>    that is poor software engineering practice. I know you disagree,
>    but I also know that some other people do agree. I suspect you
>    would be more inclined to agree if this patch had nothing to do
>    with patents.

No. Red Hat have lots of patches that belong in their products that I
know about - from removing country flags from some versions of KDE to
removing certain crypto algorithms from ssh. None are upstream, none
belong upstream. The kernel is *NOT* different to every other of the
hundreds of packages shipped by vendors.

There is an established practice over many years for this stuff, and it
is contrary to your model of messing with base reference code to meet
random national legislation.

> I suspect you are right that many vendors would apply it anyway if it
> wasn't in a kernel.org kernel. Is that sufficient to stop a new round
> of lawsuits? Maybe. If that is what is decided then I guess we'll find
> out over the next year or two.

Maybe kernel.org shouldn't be hosted in the USA. That seems to be what
the "reduce risk" argument you are making is really saying if you continue
it to its logical conclusion.

No action you take except closing down and going home determines whether
patent lawsuits get filed. You know that. In the US and quite a few other
states patent lawsuits are rarely based on fact, evidence or process.
They are a business tool used to raise costs and hamper rivals. You file
patent lawsuits to force people to use your hardware, to slow down
business rivals who are ahead in a key market and to slow adoption by
creating fear. None of it has anything to do with validity or actual
infringement.

You have about as much need for an actual infringement to file a US
patent law suit as to actually find chemical weapons in Iraq to start a
war.

