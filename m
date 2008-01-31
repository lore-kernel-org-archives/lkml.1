Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbYAaWy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbYAaWy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYAaWyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:54:20 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:15031 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYAaWyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h4oN3Ixsu/NeHcjGDMem+IpmmPFIhB3nWuhqgWQ/S0w7aGBuZLppKUTIDqMRD2oCYBbb9K64Mbg4La1ssrrKc9rLFCkuh11gX5Vo3niD/Gs/VP7+U8gM0/czVgmaKkbi2mg5vE7R0RRTgbY5SJVBCXQrElT/CjzIVh+Z2fHvkdc=
Message-ID: <4d8e3fd30801311454r3740fa85x629b22c8fbb758ef@mail.gmail.com>
Date: Fri, 1 Feb 2008 02:24:16 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 7/7] fix lines over 80 characters
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <479F200C.1020709@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129000810.42d0d6f0@paolo-desktop>
	 <479F200C.1020709@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/08, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Paolo Ciarrocchi wrote:
> > --- a/arch/x86/math-emu/errors.c
> > +++ b/arch/x86/math-emu/errors.c
> > @@ -75,7 +75,8 @@ void FPU_printall(void)
> >  	  FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
> >
> >  	  if (FPU_modrm >= 0300)
> > -	    printk(KERN_ERR " %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8,
> FPU_modrm & 7);
> > +	    printk(KERN_ERR " %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8,
> > +		FPU_modrm & 7);
> >  	  else
> >  	    printk(KERN_ERR " /%d, mod=%d rm=%d\n",
> >  		   (FPU_modrm >> 3) & 7, (FPU_modrm >> 6) & 3, FPU_modrm & 7);
> > @@ -309,7 +310,8 @@ asmlinkage void FPU_exception(int n)
> >  	printk(KERN_ERR "FPU emulator: Unknown Exception: 0x%04x!\n", n);
> >
> >        if (n == EX_INTERNAL) {
> > -	  printk(KERN_ERR "FPU emulator: Internal error type 0x%04x\n",
> int_type);
> > +	  printk(KERN_ERR "FPU emulator: Internal error type 0x%04x\n",
> > +		int_type);
> >  	  FPU_printall();
> >  	}
> >  #ifdef PRINT_MESSAGES
>
>
> The "fix" is still not conforming to CodingStyle.
>
> Besides, why don't you leave these lines as they are?  There is no
> important information hidden behind the 80th column in the existing code.


Yes, you are right.
Ingo, patch 7 deserves to be deleted.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
