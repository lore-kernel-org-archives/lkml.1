Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXLUM63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXLUM63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbXLUM6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:58:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4521 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756004AbXLUM6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:58:22 -0500
Date: Fri, 21 Dec 2007 12:58:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Bloch <matthew@bytemark.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071221125812.GA4052@ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fk8umh$n7o$1@ger.gmane.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-12-18 17:06:24, Matthew Bloch wrote:
> Hi - I'm trying to come up with a way of thoroughly testing every byte
> of RAM from within Linux on amd64 (so that it can be automated better
> than using memtest86+), and came up with an idea which I'm not sure is
> supported or practical.
> 
> The obvious problem with testing memory from user space is that you
> can't mlock all of it, so the best you can do is about three quarters,
> and hope that the rest of the memory is okay.
> 
> In order to test all of the memory, I'd like to run the user-space
> memtester over two boots of the kernel.
> 
> Say we have a 1024MB machine, the first boot I'd not specify any
> arguments and assume the kernel would start at the bottom of physical
> memory and work its way up, so that the kernel & working userspace would
> live at the bottom, and the rest would be testable from space.
> 
> On the second boot, could I then specify:
> 
> memmap=exact memmap=512M@512M memmap=512M@0

Actually, with kexec, you can probably doing without reboot.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
