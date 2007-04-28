Return-Path: <linux-kernel-owner+w=401wt.eu-S1030915AbXD1CJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030915AbXD1CJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030916AbXD1CJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:09:57 -0400
Received: from foo.birdnet.se ([213.88.146.6]:50380 "EHLO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030915AbXD1CJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:09:56 -0400
Message-ID: <20070428020950.15491.qmail@cdy.org>
Date: Sat, 28 Apr 2007 04:09:50 +0200
From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>,
       linux-pcmcia@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	"Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>,
	linux-pcmcia@lists.infradead.org,
	lkml <linux-kernel@vger.kernel.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <20070425171533.22efa133.akpm@linux-foundation.org> <D7810733513F4840B4EBAAFA64D9C6A4012D6188@stgw002a.ww002.siemens.net> <20070427190143.d597dd38.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427190143.d597dd38.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 07:01:43PM -0700, Andrew Morton wrote:
> This one-liner is turning into a fiasco.
> diff -puN drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend drivers/ide/legacy/ide-cs.c
> --- a/drivers/ide/legacy/ide-cs.c~ide-cs-recognize-2gb-compactflash-from-transcend
> +++ a/drivers/ide/legacy/ide-cs.c
> @@ -401,6 +401,8 @@ static struct pcmcia_device_id ide_ids[]
>  	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
>  	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
>  	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0xf54a91c8),
> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
>  	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
>  	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
>  	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
> _
> 
> 
> Is this really supposed to add a TS2GCF120 entry with the same IDs
> as TS4GCF120?

That's probably a copy and paste error. 0x969aa4f2 is the correct ID.


> And pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch:

This one is all right so for what it's worth, it gets:

Acked-by: Peter Stuge <peter@stuge.se>


//Peter
