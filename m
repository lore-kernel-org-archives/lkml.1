Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZFDHow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZFDHow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZFDHof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:44:35 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:45301 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZFDHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:44:33 -0400
Date: Thu, 4 Jun 2009 09:44:09 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: make blank timeout value a boot option
Message-ID: <20090604074407.GX26148@buzzloop.caiaq.de>
References: <1243953993-18608-1-git-send-email-daniel@caiaq.de> <20090604002325.5b1284de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604002325.5b1284de.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:23:25AM -0700, Andrew Morton wrote:
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -545,6 +545,10 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			console=brl,ttyS0
> >  		For now, only VisioBraille is supported.
> >  
> > +	consoleblank=	[KNL] The console blank (screen saver) timeout in
> > +			seconds. Defaults to 10*60 = 10mins. A value of 0
> > +			disables the blank timer.
> > +
> 
> It would be better to make this alterable at runtime, rather than at
> boot time.  Perhaps another VT ioctl.

That's already possible - there is an ioctl for that. It's just not
configurable at boot time, and that occured to be very annoying when
developing systems that won't fully boot up for >10mins. You have no way
to wake up the console then.

Is there any concern why that shouldn't be a kernel option?

Daniel

