Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYHSW1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYHSW1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYHSW1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:27:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53379 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756740AbYHSW1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:27:42 -0400
Date: Tue, 19 Aug 2008 23:04:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Alessandro Zummo" <a.zummo@towertech.it>,
       "Andrew Morton" <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/2] rtc: rtc-ds1374: fix 'no irq' case handling
Message-ID: <20080819230436.6b2fbb4a@lxorguk.ukuu.org.uk>
In-Reply-To: <9e4733910808191423u34946955lc85caa6b2217b390@mail.gmail.com>
References: <20080812161733.GA32164@oksana.dev.rtsoft.ru>
	<9e4733910808191339s28a05f90pef57961e8d24fbdb@mail.gmail.com>
	<20080819212937.01dfd024@lxorguk.ukuu.org.uk>
	<9e4733910808191423u34946955lc85caa6b2217b390@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know the status of these platforms....
> 
> asm-blackfin/irq.h:#define NO_IRQ ((unsigned int)(-1))
> asm-mn10300/irq.h:#define NO_IRQ		INT_MAX
> asm-parisc/irq.h:#define NO_IRQ		(-1)

In need of fixing, assuming they actually use NO_IRQ for anything - don't
be mislead by the fact they may have old defines lying around.

Alan
