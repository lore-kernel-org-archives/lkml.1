Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZLNGYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZLNGYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 01:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZLNGYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 01:24:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40967 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZLNGYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 01:24:46 -0500
Date: Mon, 14 Dec 2009 07:24:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Ryan Mallon <ryan@bluewatersys.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091214062436.GJ5114@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <4B1EB57D.6070408@bluewatersys.com>
 <20091208214658.GC4164@elf.ucw.cz>
 <4B1ECEEE.3000209@bluewatersys.com>
 <4B203575.6050407@bluewatersys.com>
 <20091210172458.GJ19454@elf.ucw.cz>
 <4B2150B7.3040207@bluewatersys.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
 <20091211221015.GB24456@elf.ucw.cz>
 <20091211232838.GE12628@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211232838.GE12628@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-11 23:28:38, Russell King - ARM Linux wrote:
> On Fri, Dec 11, 2009 at 11:10:15PM +0100, Pavel Machek wrote:
> > +#include <linux/gpio.h>
> ...
> > +#include <mach/gpio.h>
> ...
> > +#include <asm/gpio.h>
> 
> Emm, this is getting really silly.
> 
> include/linux/gpio.h:
>   
>   #ifdef CONFIG_GENERIC_GPIO
>   #include <asm/gpio.h>
>   #else
>   ...
>   #endif
> 
> arch/arm/include/asm/gpio.h:
> 
>   #include <mach/gpio.h>

Fixed, thanks.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
