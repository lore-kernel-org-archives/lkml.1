Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYBKLt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYBKLt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYBKLto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:49:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:28686 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYBKLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GVzssv6hkqbckP/RQR7xPXMk1O1JX6A40I9W43wrNvcpydxSedgRaFm65uN0Ssu8m7RVQAf6/lWPHJQKGHHRwrHkzVMaPsWyIhLNA3fm1yUaiKSsN51/tj9r3onp+2LswI+suAhvwxxcmaLZuFE11Pg6SevhcrwECxitbBHR0xk=
Message-ID: <3d1754a30802110349n684ed0b5ja47f12213e65c2ff@mail.gmail.com>
Date: Mon, 11 Feb 2008 17:19:34 +0530
From: "vignesh babu bm" <vigneshbabu@gmail.com>
To: "rohit h" <hrohit85@gmail.com>
Subject: Re: [LINUX-KERNEL] C++ in linux kernel
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Joonwoo Park" <joonwpark81@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <90d987c0802110337i42082a7ew905a096028fe347b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
	 <b25c3fa70802080714m6236614i6b991dbb5d4aa20f@mail.gmail.com>
	 <Pine.LNX.4.64.0802081653560.26116@fbirervta.pbzchgretzou.qr>
	 <90d987c0802110337i42082a7ew905a096028fe347b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.vmware.com/download/server/open_source.html

On Feb 11, 2008 5:07 PM, rohit h <hrohit85@gmail.com> wrote:
>
> On Feb 8, 2008 9:24 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> > On Feb 9 2008 00:14, Joonwoo Park wrote:
> > >2008/2/8, rohit h <hrohit85@gmail.com>:
> > >> Hi,
> > >>  I am a kernel newbie.
> > >>  I tried to insmod a C++ module containing classes, inheritance.
> > >>  I am getting 'unresolved symbol' error when I use the 'new' keyword.
> > >>  What could the problem be?
> > >>
> > >>  What kind of runtime support is needed ( arm linux kernel)? Is a
> > >> patch available for it?
> > >>
> > >Please take a look at click modular router which is using c++ as a
> > >linux kernel module.
> > >http://www.read.cs.ucla.edu/click/
> > >The lib/glue.cc provides custom operator new.
> >
> > Uh, let's not make the world worse :)
> > Just call malloc from C++, and carefully select what C++ features
> > you are going to use. The VMware source for example does it right.
> >
>
> From the links given, I dig that following C++ features need runtime support:
>   a. Pure virtual functions
>   b. Global objects  : Needs compiler dependent changes
>   c. new & delete : Can use kmalloc / kfree instead
>   d. Run time type info
>   e. Exceptions
> I guess features d & e need considerable effort.
> Apart from these, am I free to use other C++ features?
> Where could I see the VMWare sources?
>
>
>
> > Compiling the kernel module with g++ is not a simple work, you may
> > need big patch for kernel itself.
>
> I don't want to compile entire kernel.
> I only want to compile my module with g++ and insmod it.
> Any hint on how to write the Makefile.
>
> Thanks in advance,
> Rohit
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
----------------------------------------------
"Why is it that every time I'm with you, makes me believe in magic?"
