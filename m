Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYDIPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYDIPGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYDIPGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:06:15 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:8648 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYDIPGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=apFMDwAciB6BEs+64k9Pdp8MSg09dJHGP5Uz0SdIdgfhtgNB8SUNr4lzozdEAOBrbE0IbANxvY71gSqcO7kA400Ou0CCCH7EFa6iKs8Vt8z0q/u5SFWp6s+UIu6KMVOJQbS1e0u0OypiSJQsX6W3SDHqKi+VM6XP/teBQ4IO5Sk=
Message-ID: <dd18b0c30804090806w6a162ca6j196d3db320d17f31@mail.gmail.com>
Date: Wed, 9 Apr 2008 15:06:09 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: suspend issue
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1207736730.4320.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
	 <1207490104.4597.36.camel@localhost> <20080406232849.GA789@elf.ucw.cz>
	 <1207736730.4320.1.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First how do I not top message?,
For the situation with suspend I was able to succeed when fglrx was
loaded(not sure about radeonhd)
In what I experienced over here: when not loading fglrx would cause my
system to recover from suspend with a blank screen then a reboot a few
seconds later. Now two days ago I upgraded Xorg to 7.3 then doing the
same test leaves me with a different result;
With having fglrx not loaded the system will recover from suspend, but
with a blank screen and no reboot a few seconds later.
I have not upgraded the opengl drivers yet. From what I can see over
here the kernel is probably O.K. This looks more like a module issue
opengl, fglrx, radeonhd etc...of the three fglrx is recovering(I
havent tried radeonhd) I will look into upgrading my opengl stuff
today  and test to see if they recover from a suspend.
regards;
               Justin P. Mattock

On Wed, Apr 9, 2008 at 10:25 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Mon, 2008-04-07 at 01:28 +0200, Pavel Machek wrote:
>  > On Sun 2008-04-06 13:55:04, Soeren Sonnenburg wrote:
>  > > On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
>  > > > Hello; I seem to have discovered something with echo mem > /sys/power/state.
>  > > > I recompile the kernel and had forgotten to compile fglrx, when
>  > > > performing a suspend without fglrx I was confronted with the dreaded
>  > > > blank screen and a reboot. then as a test I compiled fglrx and loaded,
>  > > > and to my amazement suspend reacted properly again.
>  > >
>  > > Yeah, but I it does not even work without X - console only!
>  > >
>  > > s2ram -f -p used to work since at least 2.6.20 ... and is now not
>  > > anymore in 2.6.25-*
>  >
>  > Can you do git bisect?
>
>  I just tried, and the problem is that 25-rc1 already fails to suspend -
>  so I am not sure how I could get more insight into this failure *on
>  resume*... any ideas?
>
>  Argh!
>  Soeren
>



-- 
Justin P. Mattock
