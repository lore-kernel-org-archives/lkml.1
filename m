Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZENJ3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZENJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZENJ3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:29:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58764 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZENJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:28:59 -0400
Date: Thu, 14 May 2009 11:28:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090514092854.GF1365@ucw.cz>
References: <1241097822.2516.3.camel@poy> <20090506184122.721c890d@infradead.org> <ac3eb2510905061908u7acbd1b2nf991aa85e1517fe4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905061908u7acbd1b2nf991aa85e1517fe4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > so just to state the obvious: this code is not needed to boot fast.
> > It is mostly a workaround for having a bad initrd; if you don't use an
> > initrd, or if you use an initrd that's made with the right device nodes
> > in it already, you really just don't need this.
> >
> > I would much rather that you just fix your initrd... than to put this
> > sort of thing into the kernel....
> 
> How will you solve the dynamic device numbers? They are a complete
> reality today.

Maybe dynamic device numbers are bad idea to start with? 

I'd like to keep static /dev, thank you... With big enough major/minor
space (which we have today, I believe), complexity of dynamic device
numbers can and should be avoided.

Plus... this patch 'hardcoded' device names. Why not 'hardcode'
 device numbers in the same way, so that static /dev keeps working?
Namespace should be big enough...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
