Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbYGOT0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbYGOT0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbYGOT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:26:37 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54115 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbYGOT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:26:36 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807150931010.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807150931010.3017@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:26:44 +0200
Message-Id: <1216150004.27242.72.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > Why don't you just take the kernel-supplied firmware and make it part of 
> > the kernel package? The same way the kernel-supplied modules are part of 
> > it?
> 
> And, btw, if there is something we can do to help, we obviously should.
> 
> So ask yourself (and DavidW) things like
> 
>  - Is "make firmware_install" not enough for the package build system?
> 
>  - Does it need some other way to figure out what firmware is needed for 
>    just the configured set of drivers, eg "make firmware_list"?
> 
>  - Do we need to make the firmware loader have multiple directories it 
>    looks at? Do we want first a kernel-version-specific one, then a 
>    generic fallback one, so that we can easily have per-kernel firmware, 
>    the same way we have per-kernel modules?

as just mentioned in another post. If you look at Ubuntu, their udev
helper that actually looks for the firmware and loads it into the kernel
does exactly this. Historically we have also old paths since the
agreement on /lib/firmware came later, but that is userspace policy
anyway and not part of the kernel.

Regards

Marcel


