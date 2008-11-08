Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKHNIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKHNIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 08:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYKHNIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 08:08:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50736 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYKHNIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 08:08:12 -0500
Date: Sat, 8 Nov 2008 14:09:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -next] Hibernate: Do not oops on resume if image data
	are incorrect
Message-ID: <20081108130946.GC21405@elf.ucw.cz>
References: <200811081357.42925.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811081357.42925.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-11-08 13:57:42, Rafael J. Wysocki wrote:
> Hi Len,
> 
> Please add this patch to the suspend branch.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Hibernate: Do not oops on resume if image data are incorrect
> 
> During resume from hibernation using the userland interface image
> data are being passed from the used space process to the kernel.
> These data need not be valid, but currently the kernel sometimes
> oopses if it gets invalid image data, which is wrong.  Make the
> kernel return error codes to the user space in such cases.

(Note that userspace will still be able to make it crash / execute
arbitrary code later in the game, by supplying carefully damaged
image. But that's okay and that will always be the case.)

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@suse.cz>

Looks okay to me.

Acked-by: Pavel Machek <pavel@suse.cz>

...and thanks :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
