Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbXB0NPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbXB0NPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXB0NPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:15:21 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:46809 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXB0NPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:15:18 -0500
Date: Tue, 27 Feb 2007 08:15:06 -0500
From: Kyle McMartin <kyle@parisc-linux.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: resource_size_t printk whinging
Message-ID: <20070227131506.GA3545@athena.road.mcmartin.ca>
References: <20070227041648.GB13669@athena.road.mcmartin.ca> <Pine.LNX.4.62.0702271201330.21803@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0702271201330.21803@pademelon.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 12:02:50PM +0100, Geert Uytterhoeven wrote:
> But we don't run sparse on every build. We do run gcc (a lot).
> 

We probably could, in theory...

> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -477,6 +478,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
> >  			num = (unsigned short) va_arg(args, int);
> >  			if (flags & SIGN)
> >  				num = (signed short) num;
> > +		} else if (qualifier == 'R' || qualifier == 'R') {
>                                          ^                   ^
> One of them must be lowercase `r'.
> 

Duh. I'm a muppet.
