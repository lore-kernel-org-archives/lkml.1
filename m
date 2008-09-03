Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYICOLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYICOLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYICOLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:11:06 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40223 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753531AbYICOLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:11:04 -0400
Date: Wed, 3 Sep 2008 16:11:02 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [MMC] Multiple cards on one host
Message-ID: <20080903161102.004f6f9e@mjolnir.drzeus.cx>
In-Reply-To: <20080903084343.GF4941@pengutronix.de>
References: <20080903084343.GF4941@pengutronix.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 10:43:43 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Hi,
> 
> I have a board (PXA based) which has two SD slots. It uses a gpio to
> switch between the slots. In times when the MMC subsystem implemented
> the bus topology our customer used this fact to connect the two slots on
> a single host (although it was never intended to work with SD cards, it
> seemed to work). Any idea how to implement this on recent kernels? I
> thought about registering two hosts in pxamci.c, but this seems quite
> hacky and I suppose I'll run into locking trouble.
> 

To be honest, I don't think you can sanely support it. The OMAP guys
have been playing with some kind of multiplexer in front of the
controller, but it just seems like a world of hurt to me.

Perhaps you can convert to using SPI for the second slot if the
customer really needs a design with two slots?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
