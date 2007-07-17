Return-Path: <linux-kernel-owner+w=401wt.eu-S935463AbXGQVNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935463AbXGQVNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759413AbXGQVNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:13:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:27730 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbXGQVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RbUMbKLflnZWyBeBCaV009j1RbfBE2zxKuFzCi551e7XJaQAwn/RiLPlwup86eWTJ/h3tgJkr1kuC+XRF0COU9c9FcUsiLeKQ9Gr2NS1H+1HXEXEvpSIQHskgWUwkSpqaIirCPWyFIxvEYJnbAsvYomlki354i+anPueCabaxzw=
Message-ID: <dcf706c60707171413k6becc10cv132500e0f201fc2@mail.gmail.com>
Date: Tue, 17 Jul 2007 23:13:05 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: VESAFB CUSTOM RESOLUTION
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1184705070.8642.3.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
	 <1184705070.8642.3.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Tue, 2007-07-17 at 16:13 +0200, Sasa Ostrouska wrote:
> > Hi ,
> >
> > I want to ask one question about a custom resolution in the console.
> > I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> > 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> > ugly as I get a border of about 2-3cm on one the sides of the screen.
> > So is there a way that I set the 1280x800 resolution at boot time ?
>
> 1280x800 is not a VESA standard, so you have to find out the vendor mode
> ID for it.  You can use vbetest to list all modes supported by your
> card. Or if you don't have vbetest, use X plus the 'vesa' driver and
> look at /var/log/X*.log.
>
> Choose the mode ID number you want, add 0x200 and use that.
>
> Tony

Tony, thats a nice one, I will try it, as the previous 2 proposed
didnt work for me.
Thx
Sasa
