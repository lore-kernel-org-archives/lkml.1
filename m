Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbYDKGNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbYDKGNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYDKGM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:12:59 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:33062 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYDKGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jaJB7epzKgf4ufSmV3ziKV6n3/G1HgLcD/vh1LXSTvYsYuswiMrxUvjnNetr4m6cH+80B8yIdSGexryf1YAn+3OC0FvbZZ2qFpqhHCTEHRmn5z+rRpIP1rFTxxN9Z5eBPYImmZdGO/lnuBnEyh7jYY16I+8e58pD2FPYrtvZEys=
Message-ID: <dd18b0c30804102312ybe1700dk7f7c6afab8d93249@mail.gmail.com>
Date: Fri, 11 Apr 2008 06:12:56 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: suspend issue
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1207891933.21472.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
	 <1207490104.4597.36.camel@localhost> <20080406232849.GA789@elf.ucw.cz>
	 <1207736730.4320.1.camel@localhost> <20080410100234.GB11084@ucw.cz>
	 <1207865152.21472.2.camel@localhost>
	 <dd18b0c30804102218m1fe4f1bao285640e66bc95da7@mail.gmail.com>
	 <1207891933.21472.4.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 5:32 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Fri, 2008-04-11 at 05:18 +0000, Justin Mattock wrote:
>  > On Thu, Apr 10, 2008 at 10:05 PM, Soeren Sonnenburg <kernel@nn7.de> wrote:
>  > > On Thu, 2008-04-10 at 12:02 +0200, Pavel Machek wrote:
>  > >  > On Wed 2008-04-09 12:25:30, Soeren Sonnenburg wrote:
>  > >  > > On Mon, 2008-04-07 at 01:28 +0200, Pavel Machek wrote:
>  > >  > > > On Sun 2008-04-06 13:55:04, Soeren Sonnenburg wrote:
>  > >  > > > > On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
>  > >  > > > > > Hello; I seem to have discovered something with echo mem > /sys/power/state.
>  > >  > > > > > I recompile the kernel and had forgotten to compile fglrx, when
>  > >  > > > > > performing a suspend without fglrx I was confronted with the dreaded
>  > >  > > > > > blank screen and a reboot. then as a test I compiled fglrx and loaded,
>  > >  > > > > > and to my amazement suspend reacted properly again.
>  > >  > > > >
>  > >  > > > > Yeah, but I it does not even work without X - console only!
>  > >  > > > >
>  > >  > > > > s2ram -f -p used to work since at least 2.6.20 ... and is now not
>  > >  > > > > anymore in 2.6.25-*
>  > >  > > >
>  > >  > > > Can you do git bisect?
>  > >  > >
>  > >  > > I just tried, and the problem is that 25-rc1 already fails to suspend -
>  > >  > > so I am not sure how I could get more insight into this failure *on
>  > >  > > resume*... any ideas?
>  > >  >
>  > >  > Well, 2.6.20 worked, so bisect should be easy, right?
>  > >
>  > >  I don't quite understand... 2.6.24 worked yes, but 2.6.25-rc1 didn't
>  > >  even *suspend*. However the problem lies not in suspending but no
>  > >  display on *resume*. So the bug is hidden by the hang on suspend and I
>  > >  don't see how I can check when resume broke.
>  > >
>  > >  Soeren
>  > >
>  >
>  > Do you think the problem may be with the xserver? Did you upgrade to 7.3?
>  > Over here I did the upgrade to 7.3, but with testing with vesa there
>  > seems to be no module with the xserver for vesa
>  > or at least I haven't located it yet. On a positive note suspend does
>  > work with the ati driver installer, the negative side is
>  > it doesn't work without it. So from my perspective over here, Does
>  > xserver(7.3) have vesa support?
>
>  lets focus on console only - no Xserver - no X - because already for
>  that it doesn't work.
>
>  Soeren
>

Alright; I didn't get what you said at first, but now I see.

-- 
Justin P. Mattock
