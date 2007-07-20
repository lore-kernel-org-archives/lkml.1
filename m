Return-Path: <linux-kernel-owner+w=401wt.eu-S937249AbXGTBh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937249AbXGTBh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXGTBhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:37:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:61005 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXGTBhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hRWX0yDQAaO9sHWq51h53kvu3N0W6qFtbID0emqF3bhSvJTFUejEyvagDfs5WlKwQDmjye1V0va2hK+wIiMvKExAJvENGIbnWVqNt6gJDZWO95pGQuxeNFsMHr3QOfoaDo3uNCFt7kz0ITF6+kk+7idBn95CpLTDcKnepw0K2F8=
Message-ID: <a8e1da0707191837i5c4328c4he5b3402b6e80138@mail.gmail.com>
Date: Fri, 20 Jul 2007 01:37:16 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH][resend] Remove spec doc links in hpet header files
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070719183314.2d7d2331.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720084510.GA1779@darkstar.te-china.tietoenator.com>
	 <20070719183314.2d7d2331.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/20/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 20 Jul 2007 08:45:10 +0000
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
> > Hi,
> > The links are broken, and already exist in Documentation/hpet.txt, so
> > remove them for header files.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > ---
> > include/asm-i386/hpet.h   |    6 ------
> > include/asm-x86_64/hpet.h |    6 ------
> > 2 files changed, 12 deletions(-)
> >
> > diff -pur linux/include/asm-i386/hpet.h linux.new/include/asm-i386/hpet.h
> > --- linux/include/asm-i386/hpet.h     2007-07-11 11:15:42.000000000 +0000
> > +++ linux.new/include/asm-i386/hpet.h 2007-07-11 11:16:51.000000000 +0000
> > @@ -28,12 +28,6 @@
> >
> >  #include <linux/timex.h>
> >
> > -/*
> > - * Documentation on HPET can be found at:
> > - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> > - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> > - */
> > -
> >  #define HPET_MMAP_SIZE       1024
> >
> >  #define HPET_ID              0x000
> > diff -pur linux/include/asm-x86_64/hpet.h linux.new/include/asm-x86_64/hpet.h
> > --- linux/include/asm-x86_64/hpet.h   2007-07-11 11:16:07.000000000 +0000
> > +++ linux.new/include/asm-x86_64/hpet.h       2007-07-11 11:17:03.000000000 +0000
> > @@ -1,12 +1,6 @@
> >  #ifndef _ASM_X8664_HPET_H
> >  #define _ASM_X8664_HPET_H 1
> >
> > -/*
> > - * Documentation on HPET can be found at:
> > - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> > - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> > - */
> > -
> >  #define HPET_MMAP_SIZE       1024
> >
> >  #define HPET_ID              0x000
>
> It only half-applies here because 100 monkeys are tromping all over the
> hpet code.
>
> But I'm inclined to duck it anyway: having the documentation references in
> the soruce doesn't hurt, and nobody looks in Documentation/.
>

Hi,
But at least the web urls are broken, please update to below address:
<http://www.intel.com/technology/architecture/hpetspec.htm>.

Regards
dave
