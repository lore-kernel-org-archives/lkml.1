Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbYBGRLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbYBGRLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYBGRLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:11:18 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:40736 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYBGRLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:11:17 -0500
Date: Thu, 7 Feb 2008 18:10:22 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David Brownell <david-b@pacbell.net>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Victor <linux@maxim.org.za>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] at91_mci:  use generic GPIO calls
Message-ID: <20080207181022.5ba37443@poseidon.drzeus.cx>
In-Reply-To: <47A74790.50207@atmel.com>
References: <200802011901.27532.david-b@pacbell.net>
	<47A74790.50207@atmel.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 18:12:48 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Update the AT91 MMC driver to use the generic GPIO calls instead of the
> AT91-specific calls; and to request (and release) those GPIO signals.
> 
> That required updating the probe() fault cleanup codepaths.  Now there
> is a single sequence for freeing resources, in reverse order of their
> allocation.  Also that code uses use dev_*() for messaging, and has less
> abuse of KERN_ERR.
> 
> Likewise with updating remove() cleanup.  This had to free the GPIOs,
> and while adding that code I noticed and fixed two other problems:  it
> was poking at a workqueue owned by the mmc core; and in one (rare)
> case would try freeing an IRQ that it didn't allocate.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

Applied thanks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
