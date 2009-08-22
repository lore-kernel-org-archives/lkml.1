Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbZHVWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbZHVWyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 18:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933218AbZHVWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 18:54:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:33066 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023AbZHVWyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 18:54:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19088.30487.498496.389348@pilspetsen.it.uu.se>
Date: Sun, 23 Aug 2009 00:54:15 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andries Brouwer <aeb@cwi.nl>
Subject: Re: completely hide parts of the partition table from Windows?
In-Reply-To: <19083.15853.600539.314231@pilspetsen.it.uu.se>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se>
	<20090818233256.3e378f46@lxorguk.ukuu.org.uk>
	<19083.15853.600539.314231@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Alan Cox writes:
 >  > > Any recommendations? If no existing partition table format is suitable
 >  > > for my use case then I'm perfectly willing to invent a simple new format
 >  > > and add the corresponding parser to the kernel.
 >  > 
 >  > Or if its not the boot partition can you not just tell device mapper about
 >  > it and create a device mapper device of the offset ?
 > 
 > I have no experience with the device mapper, but I'll give it a
 > try and see how it works out. Thanks for the suggestion.

Doesn't work. I have unpartitioned space at the end of /dev/sda,
but attempting to dmsetup create test --table '0 N linear /dev/sda M'
fails in dm-table:__table_get_device() with -EBUSY. It does seem to
work if the disk in question has no mounted partitions, but that
won't be the case when the disk is in my laptop.
