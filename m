Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYDOXXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYDOXXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYDOXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:23:18 -0400
Received: from iabervon.org ([66.92.72.58]:46655 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbYDOXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:23:17 -0400
Date: Tue, 15 Apr 2008 19:23:16 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Arnd Bergmann <arnd@arndb.de>, Alexia Death <alexiadeath@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
In-Reply-To: <480343F2.3040401@zytor.com>
Message-ID: <alpine.LNX.1.00.0804151910100.19665@iabervon.org>
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de> <200804140749.57049.alexiadeath@gmail.com> <200804140848.39226.arnd@arndb.de> <480343F2.3040401@zytor.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, H. Peter Anvin wrote:

> Arnd Bergmann wrote:
> > 
> > On the contrary, the USB card readers go through a lot of effort to
> > make the card look like a SCSI device, and many of these implementations
> > are buggy in some way. SD cards are defined to have 512 byte sectors, while
> > USB mass storage can theoretically have a different sector size. Of course
> > any other size than 512 bytes is likely to break some code, which you have
> > experienced.
> > 
> 
> Actually, I believe 2 GB (non-SDHC) *only* have 1024 byte sectors.

The most easily available SD documentation is the SanDisk product manual 
(1.9) and the cards it documents only support 512-byte blocks ("The 
default block length is as specified in the CSD (512 bytes). A set block 
length of less than 512 bytes will cause a write error. The only valid set 
block length is 512 bytes. CMD16 is not manditory if the default is 
accepted.")

Somewhat unsurprisingly, not all manufacturers took into account the 
possibility that a card would use a different block size than what all of 
the cards of the time used.

	-Daniel
*This .sig left intentionally blank*
