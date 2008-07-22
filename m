Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYGVOxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYGVOxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYGVOxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:53:33 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7250 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751014AbYGVOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:53:33 -0400
Date: Tue, 22 Jul 2008 18:53:30 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <kumar.gala@freescale.com>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: latest tree build failure -- cpm uart & gpio
Message-ID: <20080722145330.GA2315@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 08:54:16AM -0500, Kumar Gala wrote:
> can someone look at the following compile failure in linus's tree.  I'm 
> guessing part of this has to do with Alan's tty changes (and might  
> already be addressed?).
>
> include/asm-generic/gpio.h:131: error: implicit declaration of function 
> 'gpio_get_value'
> include/asm-generic/gpio.h:137: error: implicit declaration of function 
> 'gpio_set_value'

I think this patch should help:

[OF] of_gpio: should use new <linux/gpio.h> header
http://patchwork.ozlabs.org/linuxppc/patch?id=18750

David, can you please Ack it? See Benjamin's mail:
http://ozlabs.org/pipermail/linuxppc-dev/2008-July/060109.html

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
