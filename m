Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZCHNqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZCHNqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 09:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZCHNq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 09:46:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60839 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZCHNq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 09:46:28 -0400
Date: Sun, 8 Mar 2009 14:46:24 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
Message-ID: <20090308144624.26e810d3@mjolnir.ossman.eu>
In-Reply-To: <49AD1914.8030705@nokia.com>
References: <4991A00B.8040002@nokia.com>
	<20090211133004.GH478@console-pimps.org>
	<4992D90E.10506@nokia.com>
	<4992E597.2030404@nokia.com>
	<20090218211627.7c16339a@mjolnir.ossman.eu>
	<499D0B5C.4000005@nokia.com>
	<20090219112243.GB25903@console-pimps.org>
	<499D4CB6.3070807@nokia.com>
	<20090302205548.223003d5@mjolnir.ossman.eu>
	<49AD1914.8030705@nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 13:48:36 +0200
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> From 58e858f20149d279368441055d8ba3ae43a1fc6d Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Tue, 10 Feb 2009 16:32:33 +0200
> Subject: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
> 
> Commit 0d3e0460f307e84904968aad6cff97bd688583d8
> "MMC: CSD and CID timeout values" inadvertently broke
> the timeout for the MMC command SEND_EXT_CSD.
> 
> This patch puts it back again.
> 
> Depending on the characteristics of the controller,
> this bug may prevent the use of MMC cards.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---

Queued, thanks.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
