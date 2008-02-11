Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYBKLh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYBKLh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYBKLhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:37:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:13376 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYBKLhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:37:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pq9C+n0acqvNJgw+cAACjLvB0J6Y2MSqyRTBC1dUPVyNbFUEdJqotLjdZr8L+r7aBPMSPqz8xfRQMdKimiAAKslnOaTodPf0Bf5OHKLjXmQe6w7RfpAh9UCqIWike2UIPOWnQgEJzy71cammzlPar4d/trVchFBtmYBq+8lD0T0=
Message-ID: <90d987c0802110337i42082a7ew905a096028fe347b@mail.gmail.com>
Date: Mon, 11 Feb 2008 17:07:49 +0530
From: "rohit h" <hrohit85@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [LINUX-KERNEL] C++ in linux kernel
Cc: "Joonwoo Park" <joonwpark81@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802081653560.26116@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
	 <b25c3fa70802080714m6236614i6b991dbb5d4aa20f@mail.gmail.com>
	 <Pine.LNX.4.64.0802081653560.26116@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2008 9:24 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Feb 9 2008 00:14, Joonwoo Park wrote:
> >2008/2/8, rohit h <hrohit85@gmail.com>:
> >> Hi,
> >>  I am a kernel newbie.
> >>  I tried to insmod a C++ module containing classes, inheritance.
> >>  I am getting 'unresolved symbol' error when I use the 'new' keyword.
> >>  What could the problem be?
> >>
> >>  What kind of runtime support is needed ( arm linux kernel)? Is a
> >> patch available for it?
> >>
> >Please take a look at click modular router which is using c++ as a
> >linux kernel module.
> >http://www.read.cs.ucla.edu/click/
> >The lib/glue.cc provides custom operator new.
>
> Uh, let's not make the world worse :)
> Just call malloc from C++, and carefully select what C++ features
> you are going to use. The VMware source for example does it right.
>

>From the links given, I dig that following C++ features need runtime support:
   a. Pure virtual functions
   b. Global objects  : Needs compiler dependent changes
   c. new & delete : Can use kmalloc / kfree instead
   d. Run time type info
   e. Exceptions
I guess features d & e need considerable effort.
Apart from these, am I free to use other C++ features?
Where could I see the VMWare sources?


> Compiling the kernel module with g++ is not a simple work, you may
> need big patch for kernel itself.

I don't want to compile entire kernel.
I only want to compile my module with g++ and insmod it.
Any hint on how to write the Makefile.

Thanks in advance,
Rohit
