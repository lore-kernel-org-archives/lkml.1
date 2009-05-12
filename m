Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZELIFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZELIFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZELIFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:05:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42668 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752934AbZELIFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:05:18 -0400
Date: Tue, 12 May 2009 09:06:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Message-ID: <20090512090602.65722342@lxorguk.ukuu.org.uk>
In-Reply-To: <200905112238.55404.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>
	<200905112238.55404.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 22:38:55 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> libata uses the DMA mapping API, so it cannot be built
> on architectures that don't have DMA support.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Nakked-by: Alan Cox <alan@linux.intel.com>

Almost every PATA adapter can fall back to PIO, many are PIO only. We
need a rather cleaner way to sort this.
