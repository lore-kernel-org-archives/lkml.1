Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZKENxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZKENxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZKENxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:53:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:49588 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbZKENxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:53:24 -0500
Subject: Re: [PATCH 8/8] spi_mpc8xxx: Add support for QE DMA mode and CPM1/CPM2 chips
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164927.GH4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:47:56 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D0B2174D-6EED-4D57-A011-FAFEF64AB794@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164927.GH4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> This patch adds QE buffer descriptors mode support for the
> spi_mpc8xxx driver, and as a side effect we now support CPM1
> and CPM2 SPI controllers.
>
> That means that today we support almost all MPC SPI controllers:
>
> - MPC834x-style controllers (support PIO mode only);
> - CPM1 and CPM2 controllers (support DMA mode only);
> - QE SPI controllers in CPU mode (PIO mode with shift quirks);
> - QE SPI controllers in buffer descriptors (DMA) mode;
>
> The only controller we don't currently support is a newer eSPI
> (with a dedicated chip selects and a bit different registers map).
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> drivers/spi/Kconfig       |    3 -
> drivers/spi/spi_mpc8xxx.c |  540 ++++++++++++++++++++++++++++++++++++ 
> +++++----
> 2 files changed, 500 insertions(+), 43 deletions(-)

applied to next

- k
