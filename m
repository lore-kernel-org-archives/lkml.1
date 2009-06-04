Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZFDISD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZFDISD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZFDIRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:17:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945AbZFDIRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:17:47 -0400
Date: Thu, 4 Jun 2009 01:17:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: make blank timeout value a boot option
Message-Id: <20090604011740.5879732c.akpm@linux-foundation.org>
In-Reply-To: <20090604074407.GX26148@buzzloop.caiaq.de>
References: <1243953993-18608-1-git-send-email-daniel@caiaq.de>
	<20090604002325.5b1284de.akpm@linux-foundation.org>
	<20090604074407.GX26148@buzzloop.caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 09:44:09 +0200 Daniel Mack <daniel@caiaq.de> wrote:

> On Thu, Jun 04, 2009 at 12:23:25AM -0700, Andrew Morton wrote:
> > > --- a/Documentation/kernel-parameters.txt
> > > +++ b/Documentation/kernel-parameters.txt
> > > @@ -545,6 +545,10 @@ and is between 256 and 4096 characters. It is defined in the file
> > >  			console=brl,ttyS0
> > >  		For now, only VisioBraille is supported.
> > >  
> > > +	consoleblank=	[KNL] The console blank (screen saver) timeout in
> > > +			seconds. Defaults to 10*60 = 10mins. A value of 0
> > > +			disables the blank timer.
> > > +
> > 
> > It would be better to make this alterable at runtime, rather than at
> > boot time.  Perhaps another VT ioctl.
> 
> That's already possible - there is an ioctl for that. It's just not
> configurable at boot time, and that occured to be very annoying when
> developing systems that won't fully boot up for >10mins. You have no way
> to wake up the console then.

Oh.  Your changelog sucked :)

> Is there any concern why that shouldn't be a kernel option?

I suppose it makes sense.  You really have systems which take more than
ten minutes to start running initscripts?  Poor you.

Please resend with a more complete description?
