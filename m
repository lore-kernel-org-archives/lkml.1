Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXBVIBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXBVIBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933003AbXBVIBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:01:54 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:26939 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbXBVIBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PJEQR0xb+ge8dsYQcwmidgMTNssAUUa713eHomM65KZdGafqckUnyTnGfc+7NrU+aSnlZkN8KuwQLreUea/i+f68UL3l0n+rlfN4fsr9+94o9cVOiyQF/nf7zmXdT4YWaHYgkIg9/HD2PDqX68MuCb7Bgc+YzT1tWQzawMn7Z78=
Message-ID: <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
Date: Thu, 22 Feb 2007 09:01:52 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       "Luca Tettamanti" <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1172101406.4217.16.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
	 <1172101406.4217.16.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Wed, 2007-02-07 at 00:08 +0100, Giuseppe Bilotta wrote:
> >
> > As mentioned in another post in this thread, I can't get any info out
> > of the i2c busses, because even when I have them available (i.e. after
> > loading nvidiafb) I get XXXX all around (on all three of them).
> > Suggestions on how to get the information welcome.
>
> Is this the same monitor you posted here?
>
> http://marc.theaimsgroup.com/?l=linux-kernel&m=112807065616218&w=2
>
> If yes, we already have the manufacturer and model code. The main
> problem is that the EDID of this display has no sync range (H: 75-75kHz
> and V: 60-60Hz).  Extending Hsync from 30-75kHz as a fix to the EDID
> block shouldn't be too hard.

Yes, that's it! Jeepers, I can't believe that even re-reading the past
LKML posts (even those!) I couldn't find the EDID info and how we had
gotten them. I guess I need stronger glasses.

Wonder why Luca's proposed patch makes the EDID undetectable, now, and
why can't it be retrieved at a later time via i2c. Timeouts too small?

> I already have a patch for this which I forgot to send to you
> before :-).  If you can confirm that this is still the same hardware,
> I'll send you a test patch

Yes, it's the same hardware. I can try the patch, with or without Luca's.


-- 
Giuseppe "Oblomov" Bilotta
