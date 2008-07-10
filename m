Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbYGJTMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbYGJTMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbYGJTMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:12:37 -0400
Received: from bu3sch.de ([62.75.166.246]:60250 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759824AbYGJTMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:12:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
Date: Thu, 10 Jul 2008 21:12:09 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
References: <200807101914.10174.mb@bu3sch.de> <20080710160258.4ddb5c61@gaivota>
In-Reply-To: <20080710160258.4ddb5c61@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102112.09532.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 21:02:58 Mauro Carvalho Chehab wrote:
> and your Kconfig allows someone
> to compile both the real driver and the gpio only driver

No it doesn't.

> So, this will cause a regression.

No it isn't.

> One alternative would be to make the gpio driver dependent of !VIDEO_BT848.

+config GPIO_BT8XX
+       tristate "BT8XX GPIO abuser"
+       depends on PCI && VIDEO_BT848=n

> Btw, if you are thinking on using it for your electronics hacking, one very
> interesting feature would be to use the bttv 8-bit high speed ADC as a generic
> ADC. On its normal operation, it samples from video inputs at 27 MHz (maybe you
> can sample on even higher frequencies, by properly configuring the sampling divider).

Cool, nice to know. But I'm currently only interested in digital IO.

-- 
Greetings Michael.
