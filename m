Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYFJSwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYFJSwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYFJSwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:52:20 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:62363 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYFJSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hosBdx47Xn4QKk4Kl+TDhO87MF2uO3RFOLOr2PGMN01C5ofJnQR8cvegIwax/IxtiT
         duLRgCWh1wZLX6vIqVoxT5ByRlgfCbfMUpk/xkAflYkYS2TcIu2le9uwufczlbEOf6Ce
         ycym21LzXAVsbNX/S8TrUxarLEw2InW79JqGc=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Greg KH <greg@kroah.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 18:49:12 +0000
User-Agent: KMail/1.9.9
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org
References: <200806010415.05290.chris2553@googlemail.com> <1212950276.3574.7.camel@localhost.localdomain> <20080609230747.GD23391@kroah.com>
In-Reply-To: <20080609230747.GD23391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101849.12637.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008, Greg KH wrote:
> On Sun, Jun 08, 2008 at 01:37:56PM -0500, James Bottomley wrote:
> > > Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose
> > > USB debugging on. A boot log from that kernel is attached. You will see
> > > lots of ETIME errors from usb. A log from a similarly verbose 2.6.25.5
> > > kernel does not show these errors. usb-devel added to cc list.
> >
> > I'm starting to think this might be a distribution problem.  I tried
> > booting my laptop on your config (only system I have with ata_piix)
> > without an initrd (bit painful for fedora 9) and I didn't see any slow
> > downs (in fact it was a lot faster than previously; makes note to file
> > bug with redhat about their initramfs).
>
> What distro is this being seen on?  I know that openSUSE 11.0 betas did
> have a bug in their init scripts that was causing a long delay, much
> like this one.  But it has been fixed in the later releases
> (hopefully...)
>

As I repied to James a few minutes ago, my desktop system was originally (the 
now lapsed) Peanut Linux, which was a Slackware derivative. But I've been 
running it for 3 or 4 years, upgrading and adding packages along the way. My 
udev setup is based on that in a fairly recent Slackware, although I can't now 
recall precisely which version.

Thanks

Chris

> thanks,
>
> greg k-h



-- 
Beauty is in the eye of the beerholder.
