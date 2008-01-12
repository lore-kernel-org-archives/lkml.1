Return-Path: <linux-kernel-owner+w=401wt.eu-S1763320AbYALL5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763320AbYALL5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761117AbYALL5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:57:47 -0500
Received: from brick.kernel.dk ([87.55.233.238]:5635 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761072AbYALL5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:57:46 -0500
Date: Sat, 12 Jan 2008 12:57:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on  SEGA Dreamcast
Message-ID: <20080112115740.GH6258@kernel.dk>
References: <1200007549.6349.16.camel@localhost.localdomain> <1200088609.6213.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200088609.6213.3.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2008, Adrian McMenamin wrote:
> 
> On Thu, 2008-01-10 at 23:25 +0000, Adrian McMenamin wrote:
> > From: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > 
> > This patch adds support for the GD-Rom drive, SEGA's proprietary implementation of an IDE CD Rom for the SEGA Dreamcast. This driver implements Sega's Packet Interface (SPI) - at least partially. It will also read disks in SEGA's propreitary GD format.
> > 
> > Unlike previous drivers (which were never in mainline) this uses DMA and not PIO to read disks. It is a new driver, not a refactoring of old drivers. 
> > 
> > Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > 
> > (Jens - this awaits your ack before going in Paul's queue for the 2.6.25 window)
> > 
> > --------
> > 
> > 
> 
> Unfortunately, there was one small mistake (a repeated assignment), in
> the patch posted yesterday. Here is a corrected version.
> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

The io handling looks ok to me now.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

