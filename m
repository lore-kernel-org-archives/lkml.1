Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYKSSnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYKSSnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYKSSnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:43:12 -0500
Received: from server.drzeus.cx ([85.8.24.28]:46924 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752779AbYKSSnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:43:12 -0500
Date: Wed, 19 Nov 2008 19:43:09 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 7/7] SDHCI: Add change_clock callback for glue drivers
Message-ID: <20081119194309.0982a47e@mjolnir.drzeus.cx>
In-Reply-To: <20081115235739.GB9161@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201011.011975583@fluff.org.uk>
	<20081114232021.183de8d9@mjolnir.drzeus.cx>
	<20081115235739.GB9161@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008 23:57:39 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> 
> The controller has a number of possible clock sources, the bus clock
> it is connected to (generally called hclk) and three more clocks from
> the heirachy that is muxed/divided from either an 48MHz, 27MHz or the
> EPLL.
> 
> The callback allows the recalculation and selection of the best clock
> to run the card clock for the controller.
>  

Can these clock sources change mid-flight? Otherwise I don't see the
need for a callback up to the sdhci core. But I don't see any
connection points for such events.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
