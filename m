Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYBIApo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYBIApo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbYBIApb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:45:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:45116 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYBIAp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l2UOJ14YVH6U3rDrJyTpX4ztu8uzvCAkJQ1YOoq6HASb8VT3ECSNB2QVUXdmNb9StANvpHUv3STF8ChCORqH7B8Mu3qFoOI8TzxrQHubmlUos9EDRsNPtgvhEh1MX/zRazgvdgwUVzXJpaKG978deOpzd3Nul/i8d4/vU4VmvRQ=
Message-ID: <b25c3fa70802081645p6aad3883s6d1b5e169b3cd091@mail.gmail.com>
Date: Sat, 9 Feb 2008 09:45:26 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [LINUX-KERNEL] C++ in linux kernel
Cc: "rohit h" <hrohit85@gmail.com>, linux-kernel@vger.kernel.org
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

2008/2/9, Jan Engelhardt <jengelh@computergmbh.de>:
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

Yep, also I think that if kmalloc is possible it would better than the
operator new.

Rohit,
Compiling the kernel module with g++ is not a simple work, you may
need big patch for kernel itself.
The c++ has more internal keywords than c.
e.g) new, delete, and ::
The new and delete should be re-spelled with another names.
The '::' is used in inline assembly however in c++ it means global namespace.

In conclusion, I don't recommand c++ for linux kernel without very
special goal like the click project :)

Joonwoo
