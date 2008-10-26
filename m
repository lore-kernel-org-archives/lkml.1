Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYJZLfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYJZLfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYJZLfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:35:44 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52714 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752478AbYJZLfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:35:44 -0400
Date: Sun, 26 Oct 2008 12:35:41 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SDHCI: timeout during data transfer
Message-ID: <20081026123541.18e31c4e@mjolnir.drzeus.cx>
In-Reply-To: <68676e00810200520n6d0fb283y2ae83a0048568017@mail.gmail.com>
References: <20080923212459.GA13888@dreamland.darkstar.lan>
	<20081002101754.031d6710@mjolnir.drzeus.cx>
	<68676e00810030427g63c07643rf637ca894df795b2@mail.gmail.com>
	<20081012105227.513bb9a8@mjolnir.drzeus.cx>
	<68676e00810140234o5e85f438l18058c907a7c6260@mail.gmail.com>
	<68676e00810141413w384882dbg53af93a1b522e0d3@mail.gmail.com>
	<20081018224650.2edff23c@mjolnir.drzeus.cx>
	<68676e00810200520n6d0fb283y2ae83a0048568017@mail.gmail.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 14:20:13 +0200
"Luca Tettamanti" <kronos.it@gmail.com> wrote:

> On Sat, Oct 18, 2008 at 10:46 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > Could you try modifying line 283 of drivers/mmc/core/core.c where it
> > says "limit_us = 250000;" to 300000 instead?
> 
> 300ms seems to be enough.
> 

It might be. Your timeout will be in the neigbourhood of 500ms because
of the crappy resolution of the sdhci hardware.

Still, I'll queue up a patch for this...

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
