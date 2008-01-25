Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbYAYVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbYAYVVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYAYVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:21:10 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:40011 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYAYVVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:21:09 -0500
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
From: Jon Masters <jonathan@jonmasters.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <479A3ED3.6020808@goop.org>
References: <20080125071127.GA4860@kroah.com>
	 <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
	 <20080125185213.GA23475@suse.de>
	 <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
	 <479A3ED3.6020808@goop.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 25 Jan 2008 16:20:27 -0500
Message-Id: <1201296027.32422.80.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 11:56 -0800, Jeremy Fitzhardinge wrote:
> Linus Torvalds wrote:
> > I'm too lazy to want to do my own initrd. I just use the prepackaged ones 
> > and rely on the fact that my private kernel will refuse to load modules 
> > that aren't meant for it anyway.

> initrds generally aren't prepackaged, but generated on install (at least 
> with Fedora).  You can regenerate them with "mkinitrd -f 
> /boot/initrd-2.6.24.img 2.6.24".  Also, I find that "make 
> modules_install install" does it automatically from a kernel build.

Right. I assumed that Linus was calling mkinitrd but was being bitten by
one of the occasional assumptions (I believe we make in that script)
that certain things are always modular. I just mailed the maintainer,
suggesting we screen against the one of the Modules.* files (perhaps
Modules.order might become a good candidate in due course...).

Jon.


