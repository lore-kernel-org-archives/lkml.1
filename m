Return-Path: <linux-kernel-owner+w=401wt.eu-S1751075AbZHRVWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbZHRVWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZHRVWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:22:40 -0400
Received: from kroah.org ([198.145.64.141]:49879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZHRVWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:22:39 -0400
Date: Tue, 18 Aug 2009 14:19:46 -0700
From: Greg KH <greg@kroah.com>
To: Christian Roche <christian.roche.fr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops: sysfs: duplicate filename 'usbdev3.3_ep81' can not be
 created
Message-ID: <20090818211946.GA23309@kroah.com>
References: <589ee1d0908160656u40672d47i7a7abe9923681f09@mail.gmail.com>
 <20090817044450.GB20884@kroah.com>
 <589ee1d0908171837u70e14c41hdd6fd4ab0aa50c7@mail.gmail.com>
 <20090818015504.GA29939@kroah.com>
 <589ee1d0908181353o5a648242p702ec607b78c2e56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <589ee1d0908181353o5a648242p702ec607b78c2e56@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 09:53:51PM +0100, Christian Roche wrote:
> >> I just installed a 2.6.30 kernel:
> >>
> >> > uname -a
> >> Linux jimi 2.6.30.5-32.fc11.i586 #1 SMP Mon Aug 17 16:21:07 EDT 2009
> >> i686 i686 i386 GNU/Linux
> >>
> >> but it looks like I still have the pb. Below is what happens after the
> >> modeswitch, and the output of lsusb.
> >
> > It's harmless, only a warning, but I thought it really was fixed.  Oh
> > well, how about the 2.6.31-rc6 kernel?
> 
> Hi again Greg,
> 
> can I test again a 2.6.31 kernel with Fedora 11 ?  I don't find any
> build in this series on koji. Or should I try to compile it on my own
> ? ( argh! :-(  I haven't done that in a long time)

I do not know anything about Fedora kernels, sorry.

> Besides is this message really only a harmless warning ?

It should be.

> I'm unable to have the USB modem work on linux, and I thought this was
> due to this pb. However if you say this is really only a warning then
> I should look for another cause.
> 
> In particular I get the following error :
> > setserial /dev/ttyACM0
> /dev/ttyACM0: Input/output error

That's a different error.

> and similarly ttyACM0 (or ACM1, ACM2, which are created by the USB
> key) cannot be accessed with minicom, wvdial, etc. Do you have an idea
> what could be the culprit here ?

That's some other problem.  It would be great if you could try out the
2.6.31-rc kernel as work has gone on in this area.

thanks,

greg k-h
