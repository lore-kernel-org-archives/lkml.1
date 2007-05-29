Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbXE2Kv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbXE2Kv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbXE2Kvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:51:52 -0400
Received: from verein.lst.de ([213.95.11.210]:42729 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbXE2Kvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:51:51 -0400
Date: Tue, 29 May 2007 12:51:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Message-ID: <20070529105119.GD29351@lst.de>
References: <20070525083607.784351000@sonycom.com> <200705251850.30342.arnd@arndb.de> <Pine.LNX.4.62.0705252135010.2657@pademelon.sonytel.be> <200705252304.30396.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705252304.30396.arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 11:04:29PM +0200, Arnd Bergmann wrote:
> On Friday 25 May 2007, Geert Uytterhoeven wrote:
> > 
> > > What is the problem? Is there infrastructure missing in the
> > > CD-ROM layer?
> > 
> > As the CD/DVD/BD part just accepts SCSI/ATAPI commands (except for plain
> > read/write), I was suggested to keep it as a SCSI driver.
> 
> Ok, so I guess the tradeoff here is that by writing it as a SCSI
> driver, you don't need to implement any of the cdrom_device_ops
> yourself but instead need to fake a few of the SCSI commands
> in ps3rom_request(). Fair enough.

ps3rom is just a normal scsi low level driver.  Currently the only
attached devices or MMC devices so the sr driver attaches to it,
but if you want to hack the ps3 hardware you should be able to
attach a tape or disk aswell, and linux would work (lv1 and gameos
might of course not like this)
