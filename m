Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYLDEsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYLDEsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYLDEs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:48:29 -0500
Received: from kroah.org ([198.145.64.141]:51881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755370AbYLDEs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:48:26 -0500
Date: Wed, 3 Dec 2008 20:38:22 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 2 (staging)
Message-ID: <20081204043822.GF18027@kroah.com>
References: <20081202173101.e2b72437.sfr@canb.auug.org.au> <49357AD0.7090005@oracle.com> <20081202192952.GA2329@kroah.com> <4936F7C8.1000400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4936F7C8.1000400@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 01:19:04PM -0800, Randy Dunlap wrote:
> Greg KH wrote:
> > On Tue, Dec 02, 2008 at 10:13:36AM -0800, Randy Dunlap wrote:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20081201:
> >>>
> >>> Today's tree fails the powerpc allyesconfig build.
> >> Greg,
> >> FYI, the staging drivers still have lots of errors (as reported
> >> over 1 week ago; yes, I know, holiday time), but I've stopped reporting
> >> on them until I see some reason to think that fixes have been made.
> > 
> > I've fixed the errors that I can in my tree.  The majority of the errors
> > you are seeing are ones that are caused by api changes in other trees
> > that I can't fix up now in -staging until those changes go into Linus's
> > tree.
> > 
> > Which is fine, I'll fix them up when I push them to Linus, so you don't
> > have to worry about them.
> > 
> > Some of the other warnings are just due to horrible code, like the
> > drivers/staging/otus/ driver that has some looney macros that cause lots
> > of build warnings.  Those will take more work and I'm hoping that the
> > community of developers that have been helping out with the staging tree
> > will help there.
> 
> So this one is an API change or it's fixed in your tree but not in linux-next
> of 20081203?
> 
> drivers/built-in.o: In function `enable_oled':
> asus_oled.c:(.text+0x52c38): undefined reference to `usb_bulk_msg'

I thought this was fixed...

Ah, tricky, the dependancy is on CONFIG_USB_SUPPORT, not CONFIG_USB,
wierd that this snuck through.  I'll go fix this up, thanks for letting
me know.

greg k-h
