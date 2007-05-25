Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbXEYTZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbXEYTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXEYTZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:25:21 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:1147 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXEYTZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WjRZfIb/12RCyfhQHHp7fri75kvKPrVk8fzaAUZcUFvw80KftWw6ksAatXLdZ+fP2J4k7itmzdCzedqsHq+ObA6DOZNdCarFl2fiW/lV9y/cBk/hGpbtlvRkbMX0zyBwg/TBRjojpkrXRgbOOhxm6KTlxxKMEU5D0LjtnfHChWY=
Message-ID: <a781481a0705251225g12d2cd8eya57df87fcbfd5eed@mail.gmail.com>
Date: Sat, 26 May 2007 00:55:17 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705251335010.13229@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <m3ejl8k6e3.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
	 <m37ir0iodl.fsf@maximus.localdomain>
	 <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
	 <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
	 <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
	 <Pine.LNX.4.64.0705241239560.10926@localhost.localdomain>
	 <a781481a0705241153m29781dd2u825c0e9bfdb6beb0@mail.gmail.com>
	 <Pine.LNX.4.64.0705251335010.13229@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 5/25/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Fri, 25 May 2007, Satyam Sharma wrote:
> ...
> > 1. If this is a function _declaration_ (i.e. a prototype in some
> > header or some .c file), then remove the NORET_TYPE macro. Also,
> > if an ATTRIB_NORET or NORET_AND already exists then you're done.
> > Else, introduce an ATTRIB_NORET after the arglist but before ;
>
> actually, what i would be introducing in all cases is "__noreturn",
> the short form currently defined in compiler-gcc.h.  and i would be
> removing every instance of ATTRIB_NORET and its buddies.

Ummm ... you mean we're replacing all occurrences of ATTRIB_NORET
as well? Note that NORET_TYPE and ATTRIB_NORET are both defined
in the generic include/linux/linkage.h whereas __noreturn is in
compiler-gcc.h which is included only for gcc builds -- hence, my
preference for ATTRIB_NORET. Also, there is not even a single user of
__noreturn anywhere in the kernel code whereas ATTRIB_NORET is used
in all these places, which means it looks like to be the standard thing ...
Anyway, I'm fine either way.

Thanks,
Satyam
