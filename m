Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZGTN6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZGTN6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZGTN6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:58:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57535 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZGTN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:58:45 -0400
Date: Mon, 20 Jul 2009 09:58:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Hellstr?m <thomas@shipmail.org>
Cc: DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720135844.GA16844@infradead.org>
References: <4A647358.1040009@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A647358.1040009@shipmail.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 03:38:32PM +0200, Thomas Hellstr?m wrote:
> Hi!
>
> It appears that GPL'd DRM drivers for closed-source user-space clients  
> are becoming more common, and the situation appears to be causing a lot  
> of unnecessary work from people wanting their drivers in the mainstream  
> kernel. Arguments against pushing upstream include.
>
>    * Security.
>    * User space interface validation and maintainability.
>    * Politics

There are also useless.

> Security:
> I think from a security point of view, open docs and a thorough  
> documented security analysis by the driver writer should be sufficient.  
> This should include:

I think you're just trying to push your agenda.  Every closed driver
I had access to was an utter piece of rubbish so far, and you'll need
the code to prove otherwise.

> User-space interface:
> Historically driver-specific interfaces have really been up to the  
> driver writer and when posted for review they receive very little  
> comments unless there are things like 64/32 bit incompatibilities etc,  
> but as mentioned on the list, small programs that demonstrate the use of  
> all interface functions would be desirable, and very helpful if someone  
> decides to do write an open-source driver.

Unless you actually have a generic userspace working with all drm
drivers you'll also have a very hard time claiming it's not a derived
work of the kernel drm.   Nevermind code not having open userspace is
impossible to test properly.

> Politics:
> It's true that sometimes some people don't like the code or what it  
> does. But when this is the underlying cause of NAK-ing a driver I think  
> it's very important that this is clearly stated, instead of inventing  
> various random reasons that can easily be argued against. How should the  
> driver writer otherwise get it right? Man-years might be spent fixing up  
> drivers that will never get upstream anyway.

I think you're just trying to defend your business writing closed source
drivers.  Drivers that aren't usable without binary blobs don't have
a business in the kernel tree, and your whining doesn't help it.  You'd
be better off spending your time getting proper open drivers done than
defending doing the work to support closed binaries.
