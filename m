Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbXFUDH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbXFUDH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXFUDHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:07:20 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:31012 "EHLO
	asav08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbXFUDHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:07:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQuAGyIeUZKhRO4R2dsb2JhbACHI4dvAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Qi Yong <qiyong@mail.fc-cn.com>
Subject: Re: [patch] add printk_ratelimit to atkbd_interrupt
Date: Wed, 20 Jun 2007 23:07:17 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, michal.k.k.piotrowski@gmail.com
References: <20070620011753.GA16692@virgo.fc-cn.com> <200706200013.13029.dtor@insightbb.com> <4678D882.3090606@mail.fc-cn.com>
In-Reply-To: <4678D882.3090606@mail.fc-cn.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706202307.18565.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 03:34, Qi Yong wrote:
> Dmitry Torokhov wrote:
> > On Tuesday 19 June 2007 21:17, Qi Yong wrote:
> >   
> >> Add printk_ratelimit() to atkbd_interrupt(). I get "Spurious ACK" messages flushing on my
> >> screen. This patch helps to read the screen.
> >>
> >>     
> >
> > Will apply, thank you.
> >
> > Do you have any idea why you are getting spurios ACK messages? Do you have
> > an application fiddling with keyboard port or do you have blink driver
> > enabled?
> 
> No idea. It is at boot time.
> Yes, i have CONFIG_BLINK=y.

Disable it.

-- 
Dmitry
