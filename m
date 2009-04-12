Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbZDLPzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbZDLPzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZDLPzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:55:19 -0400
Received: from tamago.serverit.net ([91.189.209.155]:55901 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750772AbZDLPzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:55:17 -0400
X-Greylist: delayed 2442 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2009 11:55:17 EDT
Date: Sun, 12 Apr 2009 18:14:21 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.com>
X-X-Sender: szaka@tamago.serverit.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <20090412091228.GA29937@elte.hu>
Message-ID: <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
References: <20090412091228.GA29937@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds wrote:

> And people tend to really dislike hardware that forces a particular 
> filesystem on them. Guess how big the user base is going to be if you 
> cannot format the device as NTFS, for example? Hint: if a piece of 
> hardware only works well with special filesystems, that piece of hardware 
> won't be a big seller.
> 
> Modern technology needs big volume to become cheap and relevant.
> 
> And maybe I'm wrong, and NTFS works fine as-is with sectors >4kB. But let 
> me doubt that.

I did not hear about NTFS using >4kB sectors yet but technically 
it should work.

The atomic building units (sector size, block size, etc) of NTFS are 
entirely parametric. The maximum values could be bigger than the 
currently "configured" maximum limits. 

At present the limits are set in the BIOS Parameter Block in the NTFS
Boot Sector. This is 2 bytes for the "Bytes Per Sector" and 1 byte for 
"Sectors Per Block". So >4kB sector size should work since 1993.

64kB+ sector size could be possible by bootstrapping NTFS drivers 
in a different way. 

	Szaka

--
NTFS-3G: http://ntfs-3g.org
