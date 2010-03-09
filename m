Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0CIS5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:57:18 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50132 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab0CIS5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:57:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LMLp5NTav9jpTEoJy+3tHu2i6s47hDXy/NBlC21bQ5R4xfMWzH06x2IrhGXdf42TfY
         mv9ZS/5j/dmbz+yFHPUwt/w7yuFnedwZJKtYDje4zLxtA2f9aoROjF4VthBlP056BNnu
         5fTFE2T3MBdLwLGBWau9DpZR2vfo1B/jxh9Us=
Date: Tue, 9 Mar 2010 10:57:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-input@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org
Subject: Re: [BUG?] hid-core.c: hid->name = dev->manufacturer + dev->product
 ... why not + dev->serial?
Message-ID: <20100309185705.GA28000@core.coreip.homeip.net>
References: <201003071655.06644@rk-nord.at>
 <201003091342.20273@rk-nord.at>
 <20100309184127.GE19814@core.coreip.homeip.net>
 <201003091952.40853@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003091952.40853@rk-nord.at>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 07:52:40PM +0100, Melchior FRANZ wrote:
> * Dmitry Torokhov -- Tuesday 09 March 2010:
> > Have you considered the fact that maybe you not using the right interface?
> 
> No. Because I'm not talking about *writing* an application, but about
> *using* applications written by others.

Then you need to mention that to your ISV.

> The producer of my two BU0836A
> knows that the devices are different, I know that they are different,
> the kernel knows that they are different, but the applications don't
> know that, because the kernel doesn't tell them (via JSIOCGNAME).
> 
> 
> 
> > You need to work with guys at linux-iio@vger.kernel.org (which stands
> > for Industrial I/O which is exactly what you are working with).
> 
> Hmm, then I wonder why the joystick names are different on Windows and
> Linux already.  :-}
>  

Probably because these are 2 quite different OSes?

>   unpatched Linux:  "Leo Bodnar BU0836A Interface"
>   (Vista?) Windows: "BU0836A Interface" (not even the manufacturer ... pff)
> 
> Oh, well. Forget it. I'll just distribute the patch, then. I didn't have
> much hope, anyway.
>
> m.

-- 
Dmitry
