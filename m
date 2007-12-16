Return-Path: <linux-kernel-owner+w=401wt.eu-S1763575AbXLPEOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763575AbXLPEOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 23:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbXLPEOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 23:14:01 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:54953 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757843AbXLPEOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 23:14:00 -0500
Date: Sun, 16 Dec 2007 13:13:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/3] Add GD-Rom support to the SEGA Dreamcast
Message-ID: <20071216041348.GB11113@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	axboe@kernel.dk, linux-ide@vger.kernel.org
References: <8b67d60712151620s331281f4s7e150aacacff4400@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712151620s331281f4s7e150aacacff4400@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 12:20:54AM +0000, Adrian McMenamin wrote:
> This device is electrically compatible with ATA-3 IDE CD drives but
> implements a proprietary packet interface. There have been previous
> Dreamcast CD drivers around but this is new code and uses DMA as
> opposed to PIO for reads.
> 
> It also supports reading the proprietary GD Rom format disks.
> 
> The driver will live as drivers/sh/gdrom/gdrom.c
> 
No, the driver will live in drivers/cdrom if that's the API that you
depend on. The only things in drivers/sh are SH-specific bus support
code, it is not a dumping ground for unrelated drivers.
