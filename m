Return-Path: <linux-kernel-owner+w=401wt.eu-S1030218AbXAXFwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218AbXAXFwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030219AbXAXFwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:52:06 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:2097 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030218AbXAXFwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:52:05 -0500
Date: Wed, 24 Jan 2007 06:52:02 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: au1xmmc R6 response support
Message-ID: <20070124055202.GA6446@roarinelk.homelinux.net>
References: <20070123100814.GA5001@roarinelk.homelinux.net> <45B65A73.90308@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B65A73.90308@drzeus.cx>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 07:56:51PM +0100, Pierre Ossman wrote:
> > here's a trivial patch which adds R6 reponse support to the au1xmmc
> > driver. Fixes SD card detection / operation.
> > 
> NAK. MMC_RSP_R1 and MMC_RSP_R6 have the same value so this will break
> the switch.

not in my version of 2.6.20-rc5 (and 2.6.19):

#define MMC_RSP_R1	(MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)
#define MMC_RSP_R6	(MMC_RSP_PRESENT|MMC_RSP_CRC)

Without the patch, SD card detection stops with CMD7 returning error.

Thanks,

-- 
 mll.
