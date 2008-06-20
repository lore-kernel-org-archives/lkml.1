Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbYFTRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbYFTRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYFTRHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:07:19 -0400
Received: from server.drzeus.cx ([85.8.24.28]:46520 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752576AbYFTRHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:07:18 -0400
Date: Fri, 20 Jun 2008 19:07:14 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: ben@fluff.org.uk
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: MMC: correct card drivers MODULE_LICENSE() statements
Message-ID: <20080620190714.3435a8e2@mjolnir.drzeus.cx>
In-Reply-To: <20080620110702.706950986@fluff.org.uk>
References: <20080620110702.706950986@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 12:07:02 +0100
ben@fluff.org.uk wrote:

> Both the mmc_test and sdio_uart drivers' headers show that
> they are licenses under GPL version 2, but the MODULE_LICENSE
> statements say "GPL". Change the licensing statement to better
> reflect their licensing.
> 

This is the same in the entire drivers/mmc subtree. Also, some are v2
only, some are v2 or later. I don't know if there is a consensus on the
naming of these yet. Anyway, it's just used for protecting GPL-only
symbols, so I don't see much point in extending the tag beyond its
current form.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.
