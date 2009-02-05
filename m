Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZBEWNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZBEWNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZBEWNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:13:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbZBEWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:13:05 -0500
Date: Thu, 5 Feb 2009 14:12:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, michael.hennerich@analog.com,
       cooloney@kernel.org
Subject: Re: [PATCH 4/5] Blackfin SPI Driver: Add GPIO controlled SPI Slave
 Select support
Message-Id: <20090205141255.2009f858.akpm@linux-foundation.org>
In-Reply-To: <1233828453-13311-5-git-send-email-cooloney@kernel.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	<1233828453-13311-5-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Feb 2009 18:07:32 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> 
> This patch adds support for GPIO controlled SPI Chip Selects.
> To make use of this feature, set chip_select = 0 and add a proper
> cs_gpio to your controller_data.
> 
> struct spi_board_info
>         .chip_select = 0
> 
> struct bfin5xx_spi_chip
>         .cs_gpio = GPIO_P###
> 
> There are various SPI devices that require SPI MODE_0,
> and need to have the Chip Selects asserted during the entire transfer.
> Consider using SPI_MODE_3 (SPI_CPHA | SPI_CPOL) if your device allows
> it.

Cannot apply this due to previously-mentioned driver-core-tramplings.
