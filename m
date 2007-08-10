Return-Path: <linux-kernel-owner+w=401wt.eu-S934761AbXHJNfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934761AbXHJNfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbXHJNfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:35:04 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:38732 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593AbXHJNfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:35:03 -0400
Date: Fri, 10 Aug 2007 15:34:57 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmc: ignore bad max block size in sdhci
Message-ID: <20070810153457.57369903@poseidon.drzeus.cx>
In-Reply-To: <46BC591F.90505@csr.com>
References: <46BC58E8.50300@csr.com>
	<46BC591F.90505@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 13:25:03 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> mmc: ignore bad max block size in sdhci
> 
> Some SDHC cards report an invalid maximum block size, in these cases
> assume they support block sizes up to 512 bytes instead of returning
> an error.
> 
> Signed-off-by: David Vrabel <david.vrabel@csr.com>

Thanks. Applied.

I find it rather amusing that this is for a controller from a vendor
that brags about its conformance testing kits. Go figure.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
