Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYGVUsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYGVUsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYGVUsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:48:30 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8050 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751557AbYGVUs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:48:29 -0400
Date: Wed, 23 Jul 2008 00:48:27 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Kumar Gala <kumar.gala@freescale.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: latest tree build failure -- cpm uart & gpio
Message-ID: <20080722204827.GA16227@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com> <20080722145330.GA2315@polina.dev.rtsoft.ru> <200807221233.16723.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200807221233.16723.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 12:33:16PM -0700, David Brownell wrote:
> On Tuesday 22 July 2008, Anton Vorontsov wrote:
> > On Tue, Jul 22, 2008 at 08:54:16AM -0500, Kumar Gala wrote:
> > > can someone look at the following compile failure in linus's tree.  I'm 
> > > guessing part of this has to do with Alan's tty changes (and might  
> > > already be addressed?).
> > >
> > > include/asm-generic/gpio.h:131: error: implicit declaration of function 
> > > 'gpio_get_value'
> > > include/asm-generic/gpio.h:137: error: implicit declaration of function 
> > > 'gpio_set_value'
> > 
> > I think this patch should help:
> > 
> > [OF] of_gpio: should use new <linux/gpio.h> header
> > http://patchwork.ozlabs.org/linuxppc/patch?id=18750
> 
> Is that confirmed as fixing this, vs just being the Right Thing To Do?

Just applied the patch locally and the issue is not reproducible
anymore.

> > David, can you please Ack it? See Benjamin's mail:
> > http://ozlabs.org/pipermail/linuxppc-dev/2008-July/060109.html
> 
> If you like ... but this is an OF-specific change, making
> it conform with the interface spec, so I wouldn't expect
> this to need more approvals than it's already got.
> 
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Thanks.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
