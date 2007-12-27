Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbXL0WUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbXL0WUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXL0WUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:20:46 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:17300 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752828AbXL0WUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:20:45 -0500
Date: Fri, 28 Dec 2007 07:20:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
Message-ID: <20071227222015.GA26382@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Jens Axboe <jens.axboe@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1198774339.6170.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198774339.6170.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 04:52:19PM +0000, Adrian McMenamin wrote:
> This patch adds support for the CD-Rom drive on the SEGA Dreamcast.
> 
> The SEGA Dreamcast has a built in CD-Rom drive, electrically similar
> to an ATA-3 drive, but implementing a proprietary packet interface -
> the so-called Sega Packet Interface (SPI)- and also supporting a
> proprietary format of disk - the Giga Disk Rom, with a 1GB capacity.
> The drive is know as the "GD-Rom drive".
> 
> This patch partially implements the SPI and also supports reading GD
> Rom disks. Unlike previous GD Rom drivers (which were never in the
> mainline), this driver implements DMA and not PIO for reads. It is a
> new driver, not a modified version of previous drivers.
> 
> This is the fifth iteration of this patch - which should work with
> both 2.6-24-rc5 and Paul Mundt's 2.6.25 queue.
> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Looks fine to me. Thanks for cleaning it up, Adrian.
