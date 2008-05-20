Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbYETHrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbYETHrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 03:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYETHrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 03:47:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44820 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYETHrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 03:47:23 -0400
Date: Tue, 20 May 2008 09:48:19 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       Shaohua Li <shaohua.li@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: recent 2.6.26 kernel hangs at suspend
Message-ID: <20080520074819.GA15659@elf.ucw.cz>
References: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I can simulate this and it's definitely a bug, but I could only bisect
> up to a point and the kernel would not boot after tat.
> 
> The bug is that my X60s notebook would not suspend-to-ram on the 2nd try.
> 
> Boot up -> suspend to ram -> ok -> resume -> suspend to ram -> hang!
> 
> The hang would only happen while in X.
> 
> If I don't enter X, it'll not hang on suspend to ram.

Ok, so we have X in the mix.

Can you try if it happens if you disable Intel framebuffer driver?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
