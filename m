Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYARA5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYARA5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbYARA5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:57:12 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:18572 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755776AbYARA5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:57:09 -0500
Date: Fri, 18 Jan 2008 09:56:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on SEGA Dreamcast
Message-ID: <20080118005633.GA14945@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1200007549.6349.16.camel@localhost.localdomain> <1200088609.6213.3.camel@localhost.localdomain> <20080112053630.0ccb290e.akpm@linux-foundation.org> <1200351607.6196.4.camel@localhost.localdomain> <1200352635.6196.8.camel@localhost.localdomain> <1200527877.6243.3.camel@localhost.localdomain> <20080117012743.GD14107@linux-sh.org> <1200609006.6253.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200609006.6253.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:30:06PM +0000, Adrian McMenamin wrote:
> From: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
> This patch adds support for the GD-Rom drive, SEGA's proprietary
> implementation of an IDE CD Rom for the SEGA Dreamcast. This driver
> implements Sega's Packet Interface (SPI) - at least partially. It will
> also read disks in SEGA's propreitary GD format.
> 
> Unlike previous drivers (which were never in mainline) this uses DMA and
> not PIO to read disks. It is a new driver, not a refactoring of old
> drivers. 
> 
> I hope I've fixed all the white space and other issues now!
> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Looks good to me. I'll add it to my queue unless Andrew has any glaring
objections.
