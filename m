Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZI2G6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZI2G6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 02:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZI2G6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 02:58:39 -0400
Received: from relay.atmel.no ([80.232.32.139]:55048 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZI2G6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 02:58:39 -0400
Date: Tue, 29 Sep 2009 08:57:51 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: hskinnemoen@atmel.com, spi-devel-general@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] atmel_spi: fix dma addr calculation for len >
 BUFFER_SIZE
Message-ID: <20090929085751.3cc1fa3c@hskinnemoen-d830>
In-Reply-To: <1254185759.7587.180.camel@ben-desktop>
References: <1254029187.7587.146.camel@ben-desktop>
	<20090928091259.27485716@hskinnemoen-d830>
	<1254185759.7587.180.camel@ben-desktop>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette <bn@niasdigital.com> wrote:
> From: Ben Nizette <bn@niasdigital.com>
> Subject: [PATCH] atmel_spi: make "len" variable name less ambiguous in dma addr calculation
> 
> "[PATCH] atmel_spi: fix dma addr calculation for len > BUFFER_SIZE"
> fixed a bug where the "len" variable in atmel_spi_next_xfer_data() was
> taken to be the total number of bytes remaining in the transfer but it
> actually represents the number of bytes which will be sent this dma
> chunk.  While the 2 will be the same if there is less than 1 chunk to go
> (or if we aren't using a scratch buffer and therefore aren't breaking
> the transfers in to chunks), they won't be the same in general.
> 
> s/len/next_len to reflect the true nature and usage of this variable.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>

Excellent, thanks.

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
