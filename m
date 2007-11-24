Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbXKXOe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbXKXOe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 09:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXKXOeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 09:34:20 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42917 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751002AbXKXOeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 09:34:19 -0500
Date: Sat, 24 Nov 2007 15:34:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Avi Kivity <avi@qumranet.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
Message-ID: <20071124143404.GA4826@stusta.de>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743EB52.1040205@linux.vnet.ibm.com> <20071120163240.e54beed6.akpm@linux-foundation.org> <4743EF47.5000203@linux.vnet.ibm.com> <4743EFF8.9010307@qumranet.com> <20071121095821.GB1070@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071121095821.GB1070@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 10:58:21AM +0100, Sam Ravnborg wrote:
> On Wed, Nov 21, 2007 at 10:44:40AM +0200, Avi Kivity wrote:
> > Kamalesh Babulal wrote:
> > >Andrew Morton wrote:
> > >  
> > >>On Wed, 21 Nov 2007 13:54:50 +0530 Kamalesh Babulal 
> > >><kamalesh@linux.vnet.ibm.com> wrote:
> > >>
> > >>    
> > >>>The make headers_check fails,
> > >>>
> > >>>  CHECK   include/linux/usb/gadgetfs.h
> > >>>  CHECK   include/linux/usb/ch9.h
> > >>>  CHECK   include/linux/usb/cdc.h
> > >>>  CHECK   include/linux/usb/audio.h
> > >>>  CHECK   include/linux/kvm.h
> > >>>/root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires 
> > >>>asm/kvm.h, which does not exist in exported headers
> > >>>      
> > >>hm, works for me, on i386 and x86_64.  What's different over there?
> > >>    
> > >Hi Andrew,
> > >
> > >It fails on the powerpc box, with allyesconfig option.
> > >
> > >  
> > 
> > How do we fix this?  Export linux/kvm.h only on x86?  Seems ugly.
> 
> Is kvm x86 specific? Then move the .h file to asm-x86.
> Otherwise no good idea...

What about adding a whitelist in hdrcheck.sh?

For all practical purposes in userspace the compile error due to the 
non-existing asm header should be fine, so there's no reason to change 
the code in such cases. 

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

