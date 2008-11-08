Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYKHUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYKHUvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 15:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYKHUvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 15:51:07 -0500
Received: from server.drzeus.cx ([85.8.24.28]:34595 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752440AbYKHUvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 15:51:04 -0500
Date: Sat, 8 Nov 2008 21:50:56 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/3 RFC] MMC SPI support for OpenFirmware platforms
Message-ID: <20081108215056.5ad2abe7@mjolnir.drzeus.cx>
In-Reply-To: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 22:55:46 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> 
> Pierre, the approach is somewhat similar to this one:
> http://lkml.org/lkml/2008/5/26/135
> Posted few months ago.
> 
> I know you don't like it, but I ask you to reconsider it. The
> I2C and SPI cases are similar, and recently we tried to write
> bindings for some I2C GPIO controllers.
> 

This new version is a bit better in that you've generalised thing more.
I'd still prefer if we can have an interface where the driver doesn't
have to know that it is on an ACPI/OF/EFI/whatnot host, but I can live
with this model for now.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
