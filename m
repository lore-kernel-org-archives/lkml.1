Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZBRUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZBRUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZBRUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:25:19 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:59563 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZBRUZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:25:18 -0500
Date: Wed, 18 Feb 2009 21:25:15 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Green <andy@openmoko.com>
Subject: Re: [PATCH] mmc: In mmc_power_up, use previously selected ocr if
 available
Message-ID: <20090218212515.6bae1bf6@mjolnir.ossman.eu>
In-Reply-To: <20090209132806.GD3278@fedora.yogi>
References: <20090209132806.GD3278@fedora.yogi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 18:58:08 +0530
Balaji Rao <balajirrao@openmoko.org> wrote:

> When mmc_power_up is called during unsafe resume, host->ocr should be
> used instead of host->ocr_avail.
> 
> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> Cc: Andy Green <andy@openmoko.com>
> Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> ---

Hmm... This is a bit hackish and changes the previously known behaviour
of mmc_power_up(). We probably need to refactor things and have some
other explicit call from the resume path.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
