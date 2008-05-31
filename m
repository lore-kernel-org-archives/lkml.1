Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYFAOTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYFAOTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYFAOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:17:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4393 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753183AbYFAORW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:17:22 -0400
Date: Sat, 31 May 2008 09:25:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: S K <nospamnoham@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem activating multiple cores ONLY if I press any key before kernel is loaded
Message-ID: <20080531072535.GD5405@ucw.cz>
References: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-05-25 20:39:10, S K wrote:
> Hi,
> 
> This is 100% reproducible. I'm using a Shuttle SG33G5, Q9300 (45nm)
> and Fedora 9 with kernel 2.6.25.3-18.fc9.i686.
> 
> When the PC boots up, if I don't press any key till I see "Redhat nash
> version..." everything works fine (well, good enough).
> 
> But if I press a key during the boot and end up inside GRUB boot menu
> and choose Linux (Linux is the default), the boot hangs after the line
> "Booting the kernel." and before "Redhat nash..." is displayed.

USB keyboard? Try disabling usb legacy emulation in bios. If it helps,
make them fix their bios.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
