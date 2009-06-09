Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbZFIXKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbZFIXKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759636AbZFIXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:10:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759337AbZFIXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:10:12 -0400
Date: Tue, 9 Jun 2009 16:09:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH 2/9] SPI: xilinx_spi: Added platform driver and support
 for DS570
Message-Id: <20090609160954.ae0bda8e.akpm@linux-foundation.org>
In-Reply-To: <4A292043.70704@mocean-labs.com>
References: <4A292043.70704@mocean-labs.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 15:40:19 +0200
Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:

> This patch splits xilinx_spi into three parts, an OF and a platform
> driver and generic part.
> 
> The generic part now also works on X86 and also supports the Xilinx
> SPI IP DS570

Unfortunately we already have two fairly significant
drivers/spi/xilinx_spi.c patches queued in -mm:
spi-move-more-spi_setup-functionality-into-core.patch and
spi-move-common-spi_setup-functionality-into-core.patch.  Applying this
patch on top of those makes rather a mess.

Hopefully things will still be OK if I skip this patch.  You didn't
identify the dependencies between those nine patchs.  Can you please
explain that?

