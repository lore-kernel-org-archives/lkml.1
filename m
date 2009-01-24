Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZAYAAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZAYAAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 19:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZAYAAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 19:00:32 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:37121 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZAYAAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 19:00:31 -0500
Date: Sat, 24 Jan 2009 21:45:43 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add Extended CSD as a device attribute
Message-ID: <20090124214543.60d7c939@mjolnir.drzeus.cx>
In-Reply-To: <4970646E.5020404@nokia.com>
References: <496E1187.60305@nokia.com>
	<20090115160527.4cdbe94b.akpm@linux-foundation.org>
	<4970646E.5020404@nokia.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 12:41:50 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> From: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Date: Wed, 14 Jan 2009 17:45:53 +0200
> Subject: [PATCH] MMC: Add Extended CSD as a device attribute
> 
> Extended CSD is a MMC card register.  The Card Identification
> (CID) register and the Card-Specific Data (CSD) register are
> already device attributes.  As increasingly interesting
> fields are being added to Extended CSD, it seems reasonable to
> add it too.  Note that SD cards do not have an Extended CSD
> register, so it is MMC only.
> 
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---

Well, this might be interesting for debugging, but I don't see anything
of general interest for user space in there. What's your use case?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
