Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZAXR4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZAXR4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 12:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZAXR4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 12:56:17 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35180 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZAXR4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 12:56:16 -0500
Date: Sat, 24 Jan 2009 18:56:12 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090124185612.5afddbb0@mjolnir.drzeus.cx>
In-Reply-To: <20090115150003.GB6896@shadowen.org>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
	<20090112160519.3ba21848@mjolnir.drzeus.cx>
	<20090115150003.GB6896@shadowen.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 15:00:03 +0000
Andy Whitcroft <apw@canonical.com> wrote:

> 
> Would it make more sense to simply use mmc: with no data as the MODALIAS
> tag here.  And make mmc-block have mmc:* as an alias.  That way the
> actual (useless) numeric data is not exposed but we still will load the
> mmc-block module for everything exactly as we do with the udev rule.
> This should still make things work from a distro point of view and not
> expose anything which might then get relied on.  If we do it so extra
> data can still be added later we won't prevent sane data being exposed
> should we ever have any.
> 
> If you are happier with that I can re-spin the patches that way?
> 

Well, as long as we're on the track of temporary hack, we might as well
just export "mmc_block" as the modalias. Or would there be any
side-effects to that?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
