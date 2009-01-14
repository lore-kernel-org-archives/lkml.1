Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbZANX4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbZANX4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbZANX4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:56:14 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:65043 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757402AbZANX4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:56:11 -0500
Date: Thu, 15 Jan 2009 02:56:05 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Liu Dave <DaveLiu@freescale.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linuxppc-dev@ozlabs.org,
       Lai Kon-LKL001 <Konjin.Lai@freescale.com>, linux-kernel@vger.kernel.org,
       Xie Xiaobo-R63061 <X.Xie@freescale.com>,
       "D'Abbraccio Joe-LJD015" <Joe.D'abbraccio@freescale.com>
Subject: Re: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Message-ID: <20090114235605.GA13531@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090114194631.GA25978@oksana.dev.rtsoft.ru> <D7CCA83BB0796C49BC0BB53B6AB1208907ABDB@zch01exm21.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208907ABDB@zch01exm21.fsl.freescale.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 07:37:00AM +0800, Liu Dave wrote:
> > This patch adds support for the Freescale Enhanced Secure Digital
> > Host Controller Interface as found in some Freescale PowerPC
> > microprocessors (e.g. MPC837x SOCs).
> 
> The Freescale ESDHC controller is basically compatible with the
> standard SDHC controller. but the eshdc expand some bits.
> 
> The esdhc.c is much like the orignal sdhci.c.
> it is possible to merge them.

Ah. I wonder why Freescale just didn't write some patches for sdhci,
but copied the code instead...

Thanks for the info, I'll look into merging the driver into sdhci.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
