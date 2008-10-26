Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYJZLtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYJZLtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYJZLtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:49:02 -0400
Received: from server.drzeus.cx ([85.8.24.28]:34183 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbYJZLtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:49:00 -0400
Date: Sun, 26 Oct 2008 12:48:56 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] pci: use pci_ioremap_bar() in drivers/mmc
Message-ID: <20081026124856.7f2607e6@mjolnir.drzeus.cx>
In-Reply-To: <20081020215624.18c5b604@infradead.org>
References: <20081020215624.18c5b604@infradead.org>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 21:56:24 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> From 6fc220a25ecbb0576179c6b4472e7262389b25e8 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 28 Sep 2008 16:15:56 -0700
> Subject: [PATCH] pci: use pci_ioremap_bar() in drivers/mmc
> 
> Use the new pci_ioremap_bar() function in drivers/mmc.
> pci_ioremap_bar() just takes a pci device and a bar number, with the goal
> of making it really hard to get wrong, while also having a central place
> to stick sanity checks.
> 
> CC: Pierre Ossman <drzeus@drzeus.cx>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---

Looks sane. Queued.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
