Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbZLJQ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbZLJQ50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbZLJQ5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:57:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38739 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760896AbZLJQ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:57:24 -0500
Date: Thu, 10 Dec 2009 17:57:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091210165721.GI19454@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <4B1EB57D.6070408@bluewatersys.com>
 <20091208214658.GC4164@elf.ucw.cz>
 <4B1ECEEE.3000209@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1ECEEE.3000209@bluewatersys.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is still really screwy. Why are you creating your own version of
> struct gpio_chip in addition to the one in include/asm-generic/gpio.h
> (which you also appear to include in some places). It makes the code
> extremely confusing. Other architectures use wrapper structures. Can you
> have something like this instead:
> 
> 	struct dream_gpio_chip {
> 		struct gpio_chip chip;
> 
> 		/* Dream specific bits */
> 	};

Well, unfortunately dream's gpio_chip definition is completely
different to the one from include/asm-generic. I'll do the rename.

> The name of this function also needs to be changed to something less
> generic since it is being exported globally.

Well, arm only ever supports one subarch, so...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
