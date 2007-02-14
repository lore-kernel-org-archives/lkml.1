Return-Path: <linux-kernel-owner+w=401wt.eu-S1751348AbXBNXVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbXBNXVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXBNXVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:21:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:50734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXBNXVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:21:53 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: David Brownell <david-b@pacbell.net>
Subject: Re: loosen dependancy on rtc cmos
Date: Wed, 14 Feb 2007 18:20:33 -0500
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214180915.GA6412@redhat.com> <200702141155.33970.david-b@pacbell.net>
In-Reply-To: <200702141155.33970.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141820.33928.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 14:55, David Brownell wrote:
> On Wednesday 14 February 2007 10:09 am, Dave Jones wrote:
> > This option is useful for all of the X86 subarchs afaik (and especially X86_GENERICARCH).
> 
> You're right ... _potentially_ useful, which is the same standard used
> in most of the other cases.  The "X86_PC" is debris from an early version
> of this patch, which limited the code to cases where it was known to work.
> The X86_PC hardware standard does standardize on this particular RTC, but
> non-PC platforms can use it too.
> 
> I still need to resubmit the patch, for X86_PC, which defines the platform
> device in the (common) case where PNPACPI isn't defined.

CONFIG_PNPACPI=y is not the common case?

-Len

> Other X86 boards 
> would need something similar, based on what chips are wired to the CPU.
> 
> 
> > Signed-off-by: Dave Jones <davej@redhat.com>
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> 
> > --- linux-2.6.20.noarch/drivers/rtc/Kconfig~	2007-02-14 13:07:07.000000000 -0500
> > +++ linux-2.6.20.noarch/drivers/rtc/Kconfig	2007-02-14 13:07:13.000000000 -0500
> > @@ -101,7 +101,7 @@ comment "RTC drivers"
> >  
> >  config RTC_DRV_CMOS
> >  	tristate "PC-style 'CMOS' real time clock"
> > -	depends on RTC_CLASS && (X86_PC || ALPHA || ARM26 || ARM \
> > +	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
> >  		|| M32R || ATARI || POWERPC)
> >  	help
> >  	  Say "yes" here to get direct support for the real time clock
> > 
> > -- 
> > http://www.codemonkey.org.uk
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
