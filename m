Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXEIW7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXEIW7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbXEIW72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:59:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759869AbXEIW7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:59:20 -0400
Date: Wed, 9 May 2007 15:59:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] IDE update
Message-Id: <20070509155912.20596814.akpm@linux-foundation.org>
In-Reply-To: <46424F7B.8060004@garzik.org>
References: <200705100046.05280.bzolnier@gmail.com>
	<46424F7B.8060004@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 18:47:23 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Bartlomiej Zolnierkiewicz wrote:
> > * the code for selecting and programming the best DMA transfer mode
> >   has been reworked to be cleaner, more generic and more libata-like,
> >   (> 500 LOCs gone and this change allows the change described below)
> 
> > Bartlomiej Zolnierkiewicz (11):
> >       ide: rework the code for selecting the best DMA transfer mode (v3)
> 
> 
> Has this seen testing/exposure in -mm tree?
> 

argh.  If this was in a file called
ide-rework-the-code-for-selecting-the-best-DMA-transfer-mode.patch then it
would be so easy.

<logs into hera>

<greps>

ah, it's hidden in ide-max-dma-mode-v3.patch.

akpm:/usr/src/25> grep ide-max-dma-mode-v3 pc/*series
pc/2.6.21-mm1-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-mm2-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc2-mm2-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc3-mm1-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc3-mm2-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc4-mm1-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc5-mm3-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc5-mm4-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc6-mm1-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc7-mm1-series:ide-ide-max-dma-mode-v3.patch
pc/2.6.21-rc7-mm2-series:ide-ide-max-dma-mode-v3.patch

No probs.

