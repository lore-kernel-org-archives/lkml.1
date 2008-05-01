Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbYEBHBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbYEBHBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbYEBHBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:01:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56180 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYEBHBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:01:36 -0400
Date: Thu, 1 May 2008 02:00:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Message-ID: <20080501020055.4ebb6393@infradead.org>
In-Reply-To: <200805011638.15910.mb@bu3sch.de>
References: <200805011638.15910.mb@bu3sch.de>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 16:38:15 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This patchset adds API and one user for a "weak" dma_set_mask().
> Weak means that it will fallback to smaller masks in case the
> DMA subsystem rejects a big mask.
> Currently such rejection may happen if the driver requests a 64bit
> mask on a VIA machine, for example. dma_set_mask_weak() will fallback
> to 32bit, in that case, and tell the caller about it by modifying the
> passed mask.

can we just make the existing API do this instead?
