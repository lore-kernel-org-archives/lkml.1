Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbXKAOeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbXKAOeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbXKAOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:33:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4269 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756285AbXKAOdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:33:02 -0400
Date: Tue, 30 Oct 2007 14:52:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: jack@antonello.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Dell laptop backlight driver
Message-ID: <20071030145247.GE7742@ucw.cz>
References: <4724B4F5.80004@antonello.org> <20071028161955.GF23359@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028161955.GF23359@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > this driver implements backlight control on Dell laptops
> > which use SMI  for changing brightness levels.
> > 
> > The driver is INCOMPLETE since it is unable to probe some required 
> > parameters
> > in order to perform backlight control. Such parameters are found in a Dell
> > proprietary DMI table which should be parsed. For now external tools may be
> > used to find these parameters by hand. So if you intend to try this out,
> > FIRST write your laptop model parameters correctly inside the source code
> > as explained in Documentation/dell-laptop.txt.
> > 
> > Parts of this driver may also be used to provide additional functionalities
> > similarly to the drivers/misc/*-laptop.c drivers.
> 
> Why is this better done in the kernel rather than in userspace with
> libsmbios as you've noted?

Well, keeping the same interface as other notebooks has some
advantages... and means that kernel does its job - hw abstraction.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
