Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYGVWFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYGVWFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYGVWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:05:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:52816 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYGVWFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:05:40 -0400
Subject: Re: latest tree build failure -- cpm uart & gpio
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: Kumar Gala <kumar.gala@freescale.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <20080722145330.GA2315@polina.dev.rtsoft.ru>
References: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com>
	 <20080722145330.GA2315@polina.dev.rtsoft.ru>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 08:05:09 +1000
Message-Id: <1216764309.11027.211.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 18:53 +0400, Anton Vorontsov wrote:
> On Tue, Jul 22, 2008 at 08:54:16AM -0500, Kumar Gala wrote:
> > can someone look at the following compile failure in linus's tree.  I'm 
> > guessing part of this has to do with Alan's tty changes (and might  
> > already be addressed?).
> >
> > include/asm-generic/gpio.h:131: error: implicit declaration of function 
> > 'gpio_get_value'
> > include/asm-generic/gpio.h:137: error: implicit declaration of function 
> > 'gpio_set_value'
> 
> I think this patch should help:
> 
> [OF] of_gpio: should use new <linux/gpio.h> header
> http://patchwork.ozlabs.org/linuxppc/patch?id=18750
> 
> David, can you please Ack it? See Benjamin's mail:
> http://ozlabs.org/pipermail/linuxppc-dev/2008-July/060109.html
> 

Hrm.. I though I had that one in my latest batch. In fact, I just
checked and it got merged.

Ben.


