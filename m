Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbXKYSUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbXKYSUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 13:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXKYSUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 13:20:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2242 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753543AbXKYSUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 13:20:01 -0500
Date: Sun, 25 Nov 2007 18:19:34 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Raymano Garibaldi <raymano@faunos.com>
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-1] [USB Mass Storage] [USB_PERSIST] Losing mounted USB storage after resume
Message-ID: <20071125181934.GA4944@ucw.cz>
References: <1618816c0711150657p35744001ic6d4ea22d5651a63@mail.gmail.com> <473C7B59.7030601@rtr.ca> <1618816c0711151357g56d4ab4q8b9d8c6a4c5bfd51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618816c0711151357g56d4ab4q8b9d8c6a4c5bfd51@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The scenario that you've described is exactly what I have in mind as
> well. The lack of this feature, which worked fine in 2.6.21, is
> holding us back on updating the kernel in our LiveUSB distribution. I
> think that this is a feature that would be more and more needed as
> portable storage devices start growing in capacity and speed and start
> getting smaller in physical size.
> 
> Please advise us on how to accomplish this. Kernel boot option; patch;
> anything! We'll take anything.

This is tricky to do safely. You could verify during resume that fs
was not modified (same last mount date on ext2) and if it was not,
just proceed as if it was not unmounted. Patch would be warmly
welcome.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
