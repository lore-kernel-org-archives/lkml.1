Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZAaOKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZAaOKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZAaOJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:09:57 -0500
Received: from nn7.de ([85.214.94.156]:42919 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbZAaOJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:09:56 -0500
Subject: Re: 2.6.29-rc3+git macbook pro1,1 garbled display on resume
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Justin P\. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xdg@lists.freedesktop.org
In-Reply-To: <49845124.9080206@gmail.com>
References: <1233348609.3707.6.camel@localhost>  <4983F365.40701@gmail.com>
	 <1233400739.4140.3.camel@localhost>  <49845124.9080206@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 31 Jan 2009 15:09:52 +0100
Message-Id: <1233410992.14295.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 05:24 -0800, Justin P. Mattock wrote:
> Soeren Sonnenburg wrote:
> > On Fri, 2009-01-30 at 22:44 -0800, Justin P. Mattock wrote:
> >   
> >> Soeren Sonnenburg wrote:
> >>     
> >>> Hi,
> >>>
> >>> the macbook pro suspends just fine, but even though the machine returns
> >>> to X I see on resume some random garbled output but can still move the
> >>> mouse cursor (which is OK!) and using the keyboard successfully adjust
> >>> the brightness of the display.
> >>>       
> > [...]
> > I recognized that everything seems to work just fine *on console only*.
> > At least I could suspend and resume via s2ram >3 times in a row.
> >
> > What also worked was to just start plain X (no window manager or
> > anything) and suspend/resume then. However with compiz running I am
> > seeing the garbage/hang on resume.
> >
> > Are you by chance to having an ATI card + use a compositing window
> > manager?
> >
> > Soeren
> >
> >   
> At the moment I don't have compiz manager
> running, only fluxbox. But after thinking,
> I did experience this(choppy screen)when using kexec,
> i.g. starting a new kernel from a terminal inside the xserver
> did create a messed up screen. Then(ctl+alt+del)disabling
> the xserver, made things work the way they were supposed too.
> 
> I am running radeon on a macbook pro. If I can remember
> at the time I was using kexec I did have radeon.(I'll try and reproduce 
> this though).
> In any case I think this is an xserver issue not a kernel(but thats just 
> a guess).
> I added a cc (hopefully it's the right one);

Could be... I've tried with a more recent radeon driver, i.e. 
xserver-xorg-video-radeon    deb-version        1:6.10.0-2 - same thing.

Is anyone aware of a known-to-work radeon version that I should try?

Soeren
