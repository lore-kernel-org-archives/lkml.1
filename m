Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYDIHTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYDIHTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYDIHTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:19:42 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:2704 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYDIHTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l6cF28stDwaY9CYGgUFiyZvWKIFcPc6qlpzr7rsR3PWELbL1fcMdkhoek/vNYQekd1ved9vdSZJUxw70boTqOZtFvI54A4CvQDE+ojlV+6DAv8OPQ5BVCKp32QpMKIRRz4JVU7ONlgpY7k+d93f9MTpKHC9SQvFmtZ6TmUAsW08=
Message-ID: <bc64b4640804090019n2f895189i2efaf16401bc34f6@mail.gmail.com>
Date: Wed, 9 Apr 2008 11:19:40 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
In-Reply-To: <20080408200721.GC18053@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	 <20080403132411.GA27017@doriath.ww600.siemens.net>
	 <20080407160155.5e6d77f0.akpm@linux-foundation.org>
	 <bc64b4640804080252q6e295eeege7004013406ad3d8@mail.gmail.com>
	 <20080408193502.GB18053@flint.arm.linux.org.uk>
	 <bc64b4640804081258g318b69f7l6d5ea2b38edb53a2@mail.gmail.com>
	 <20080408200721.GC18053@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/9, Russell King <rmk+lkml@arm.linux.org.uk>:
> On Tue, Apr 08, 2008 at 11:58:11PM +0400, Dmitry wrote:
>  > 2008/4/8, Russell King <rmk+lkml@arm.linux.org.uk>:
>
> > > So... what is the correct name.  Bear in mind what I said in the previous
>  > >  reply this evening - which says that it should be the name used by the
>  > >  SA1111.  Look in the data sheet - the pin itself to which the 3.6MHz
>  > >  clock is supplised will have a name.  That's the name which should be
>  > >  used.
>  >
>  > I use the same pin/clock for the tc6393xb driver. And I'm pretty sure
>  > the datasheets won't agree on the name of the pin. Which name should I
>  > use?
>
>
> You missed the fundamental issue about the clock API - the _name_ is
>  not the clock name defined by the host.  It's the _device_ clock name.
>
>  So, you shouldn't be using the SA1111 clock name for the tc6393xb driver.
>  You should be using its own name.  The platform specific bit of the clock
>  API is then supposed to return you the struct clk corresponding with
>  that input, by using the platform knowledge that it's connected to GPIO27
>  or whatever.

I think I understood your idea. I'll repost updated patchset later.

-- 
With best wishes
Dmitry
