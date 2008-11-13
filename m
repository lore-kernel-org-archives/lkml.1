Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYKML0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYKML0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYKML0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:26:34 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:62513 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYKML0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:26:33 -0500
Date: Thu, 13 Nov 2008 12:26:28 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
Message-ID: <20081113122628.0327e07b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <491C0C05.6040301@atmel.com>
References: <491C0C05.6040301@atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2008 11:26:09.0706 (UTC) FILETIME=[A07818A0:01C94582]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Needed to use the atmel-mci driver in a architecture
> independent manner.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/avr32/boards/atngw100/setup.c       |    2 +-
>  arch/avr32/boards/atstk1000/atstk1002.c  |    2 +-
>  arch/avr32/boards/atstk1000/atstk1003.c  |    2 +-
>  arch/avr32/boards/atstk1000/atstk1004.c  |    2 +-
>  arch/avr32/include/asm/atmel-mci.h       |   39 ------
>  arch/avr32/mach-at32ap/at32ap700x.c      |    2 +-
>  drivers/mmc/host/atmel-mci.c             |    2 +-
>  include/linux/atmel-mci.h                |   39 ++++++
>  8 files changed, 45 insertions(+), 45 deletions(-)
>  delete mode 100644 arch/avr32/include/asm/atmel-mci.h
>  create mode 100644 include/linux/atmel-mci.h

Please fix up the mimc200 board too. If you do that, feel free to add

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
