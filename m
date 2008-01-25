Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYAYW15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYAYW15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYAYW1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:27:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbYAYW1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:27:44 -0500
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <479A5B72.6080701@goop.org>
References: <20080125071127.GA4860@kroah.com>
	 <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
	 <20080125185213.GA23475@suse.de>
	 <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
	 <479A3ED3.6020808@goop.org> <1201296027.32422.80.camel@perihelion>
	 <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org>
	 <479A5B72.6080701@goop.org>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 23:26:19 +0100
Message-Id: <1201299979.27573.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 13:58 -0800, Jeremy Fitzhardinge wrote:
> Linus Torvalds wrote:
> > On Fri, 25 Jan 2008, Jon Masters wrote:
> >   
> >> Right. I assumed that Linus was calling mkinitrd but was being bitten by
> >> one of the occasional assumptions (I believe we make in that script)
> >>     
> >
> > No. I really am not. My /etc/grub.conf looks like this:
> >
> > 	title Linux
> > 	        root (hd0,0)
> > 	        kernel /vmlinuz ro root=/dev/VolGroup00/LogVol00 rhgb quiet
> > 	        initrd /initrd-2.6.23.14-107.fc8.img
> >
> > ie I literally run the fedora initrd.
> >
> > I switch kernels, not initrd's. I don't even want to know if the initrd 
> > contains some distro-specific setup...
> 
> The distro mkinird can reconstruct it containing your freshly built 
> modules (if any) and any other distro goo which needs to go in there.   
> /initrd-2.6.23.14-107.fc8.img doesn't come out of an rpm; its built by 
> an installer script when you install the kernel, and you can run the 
> same script on your kernels.
> 
> Does you use "make modules_install install" when you build the kernel? 
> It just does the right thing for me under F8, including rebuilding 
> initrd and updating grub.conf.

My wish is that distros would just boot without requiring an initrd. I
know how to make them for redhat and debian based distros, but the fact
that you can't (easily) cross-build them makes it a very tedious
construct.

I can butcher the distros into booting and ignore the errors on bootup
that whine that modules are missing, but really.

