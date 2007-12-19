Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbXLSQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbXLSQ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXLSQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:57:12 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:34886 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXLSQ5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:57:11 -0500
Date: Wed, 19 Dec 2007 17:57:08 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] sdio: move temporary buffer
Message-ID: <20071219175708.46c781ac@poseidon.drzeus.cx>
In-Reply-To: <200712191155.26594.marc.pignat@hevs.ch>
References: <200712191155.26594.marc.pignat@hevs.ch>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 11:55:25 +0100
Marc Pignat <marc.pignat@hevs.ch> wrote:

> Move the temporary buffer used by some sdio functions from sdio_func struct to
> the mmc_host struct and make it dma-safe.
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> ---
> 
> There is no need to have this temporary buffer in every sdio_func, since all
> access to it are serialized by sdio_[claim/release]_host.
> 

I had some crazy idea about per function locking, but until that time this will do just fine.

> I also think it should be ____cacheline_aligned to make sure we have no data
> loss when doing dma syncing operations.

This is still voodoo to me, so I'll have to take your word for it. :)

> 
> Comments welcome!
> 

Looks good to me.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
