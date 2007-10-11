Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbXJQNMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbXJQNMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbXJQNL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:11:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3776 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754356AbXJQNL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:11:56 -0400
Date: Thu, 11 Oct 2007 18:11:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       adaplas@gmail.com
Subject: Re: [PATCH] vc bell config
Message-ID: <20071011181137.GA3868@ucw.cz>
References: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It is already possible to deactivate the vc bell on a per-tty basis,
> by using echo -en "\e[11;0]", but this is reset on reset(1).
> 
> This adds a sysfs parameter to globally control the vc bell, as well
> as sysfs parameters for default pitch and duration.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

There are more parameters that should be set during reset... like
cursor size and color, palette, .... What about /sys/.../string_to_interpret
_on_reset ?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
