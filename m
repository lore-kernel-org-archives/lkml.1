Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYLaSDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYLaSDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYLaSDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:03:38 -0500
Received: from server.drzeus.cx ([85.8.24.28]:33857 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756091AbYLaSDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:03:37 -0500
Date: Wed, 31 Dec 2008 19:03:34 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: Add support for OpenFirmware bindings
Message-ID: <20081231190334.137ba624@mjolnir.drzeus.cx>
In-Reply-To: <20081230151528.GA14950@oksana.dev.rtsoft.ru>
References: <20081230151528.GA14950@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 18:15:28 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> The support is implemented via platform data accessors, new module
> (of_mmc_spi) will be created automatically when the driver compiles
> on OpenFirmware platforms. Link-time dependency will load the module
> automatically.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

Queued up.

> 
> Hello Pierre,
> 
> All the needed patches were merged into Linus' tree, so I believe
> it's time for the bindings.
> 
> Note that you need to pull Linus' tree into mmc.git's next branch
> before applying this patch, otherwise it will break bisect, since
> of_mmc_spi isn't buildable without some patches that are in Linus'
> tree, but not in the current mmc.git next.
> 

mmc.git#next gets rebased constantly to the current linus HEAD, so this
isn't a problem. And since this doesn't really mess with the old SPI
driver, I'm pushing this for .29.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
