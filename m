Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZBBT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZBBT0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZBBT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:26:37 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50518 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZBBT0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:26:36 -0500
Date: Mon, 2 Feb 2009 20:26:32 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add Extended CSD as a device attribute
Message-ID: <20090202202632.2267aa0a@mjolnir.drzeus.cx>
In-Reply-To: <497D7F74.6050409@nokia.com>
References: <496E1187.60305@nokia.com>
	<20090115160527.4cdbe94b.akpm@linux-foundation.org>
	<4970646E.5020404@nokia.com>
	<20090124214543.60d7c939@mjolnir.drzeus.cx>
	<497D7F74.6050409@nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 11:16:36 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> 
> Yes it is mainly just debugging.  It was done as a device attribute for
> consistency with the other card registers CID and CSD.
> 
> Would you prefer #ifdef CONFIG_MMC_DEBUG or debugfs?

debugfs if it's not too much trouble. Noone can claim they didn't
understand it was only for debugging there. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
