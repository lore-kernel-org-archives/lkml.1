Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXKUJ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXKUJ4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXKUJ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:56:40 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47283 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXKUJ4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:56:39 -0500
Date: Wed, 21 Nov 2007 10:58:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
Message-ID: <20071121095821.GB1070@uranus.ravnborg.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743EB52.1040205@linux.vnet.ibm.com> <20071120163240.e54beed6.akpm@linux-foundation.org> <4743EF47.5000203@linux.vnet.ibm.com> <4743EFF8.9010307@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4743EFF8.9010307@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 10:44:40AM +0200, Avi Kivity wrote:
> Kamalesh Babulal wrote:
> >Andrew Morton wrote:
> >  
> >>On Wed, 21 Nov 2007 13:54:50 +0530 Kamalesh Babulal 
> >><kamalesh@linux.vnet.ibm.com> wrote:
> >>
> >>    
> >>>The make headers_check fails,
> >>>
> >>>  CHECK   include/linux/usb/gadgetfs.h
> >>>  CHECK   include/linux/usb/ch9.h
> >>>  CHECK   include/linux/usb/cdc.h
> >>>  CHECK   include/linux/usb/audio.h
> >>>  CHECK   include/linux/kvm.h
> >>>/root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires 
> >>>asm/kvm.h, which does not exist in exported headers
> >>>      
> >>hm, works for me, on i386 and x86_64.  What's different over there?
> >>    
> >Hi Andrew,
> >
> >It fails on the powerpc box, with allyesconfig option.
> >
> >  
> 
> How do we fix this?  Export linux/kvm.h only on x86?  Seems ugly.

Is kvm x86 specific? Then move the .h file to asm-x86.
Otherwise no good idea...

	Sam
