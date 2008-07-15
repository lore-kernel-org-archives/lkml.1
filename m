Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYGONBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYGONBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYGONAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:00:52 -0400
Received: from bu3sch.de ([62.75.166.246]:49714 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbYGONAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:00:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH] Add dynamic MMC-over-SPI-GPIO driver
Date: Tue, 15 Jul 2008 15:00:16 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807142109.19360.mb@bu3sch.de> <1216098409.4265.144.camel@moss.renham>
In-Reply-To: <1216098409.4265.144.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151500.17197.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008 07:06:49 Ben Nizette wrote:
> 
> On Mon, 2008-07-14 at 21:09 +0200, Michael Buesch wrote:
> > This driver provides a sysfs interface to dynamically create
> > and destroy GPIO-based MMC/SD card interfaces.
> > So an MMC or SD card can be connected to generic GPIO pins
> > and be configured dynamically from userspace.
> 
> Can you use mmc-spi attached to spi-gpio and be done with it?

This is _exactly_ what this module does. It combines mmc-spi and
spi-gpio and creates an actual device for them.

> Sure you 
> won't have the dynamic alloc capability but you won't be reinventing the
> wheel either.

This does not reinvent anything. It just wires up the two modules.

-- 
Greetings Michael.
