Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYHVTth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYHVTth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYHVTt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:49:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYHVTt0 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:49:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
Date: Fri, 22 Aug 2008 21:49:20 +0200
User-Agent: KMail/1.9.9
Cc: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD0101.4020505@gmail.com> <200808221852.38950.arnd@arndb.de> <48AEF976.1010705@lougher.demon.co.uk>
In-Reply-To: <48AEF976.1010705@lougher.demon.co.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808222149.21186.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+mWKQjBMNeFCTSZywP6cB53u+C3cxd7OSDaP+
 1I0x95hdkG/1CUzjAGVaWgkvXX6goic96yFNwpfCg8LNn0KGs3
 yMiU/CfD+NSdAGJqhufbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008, Phillip Lougher wrote:
> 1. Support for > 4GB filesystems.  In theory 2^64 bytes.
> 2. Compressed metadata
> 3. Inode timestamps
> 4. Hard-link support, and correct nlink counts
> 5. Sparse file support
> 6. Support for ". & ".." in readdir
> 7. Indexed directories for fast lookup
> 8. NFS exporting
> 9. No need to cache entire metadata in memory
>
> Squashfs has been optimised for block-based rotating media like hard 
> disks, CDROMS.  AXFS has been optimised for flash based media.  Squashfs 
> will outperform AXFS on rotating media, AXFS will outperform Squashfs on 
> flash based media.

Ok, thanks for the list. I'm sure that sparse files are already
part of AXFS, and among the other things, I would consider some
to be AXFS bugs rather than squashfs features ("." in readdir, in
particular), but I get the point.

> Squashfs and AXFS should be seen as complementary filesystems, and there 
> should be room in the Linux kernel for both.
> 
> I don't see what your problem is here.  I think AXFS is an extremely 
> good filesystem and should be merged.  But I don't see why this should 
> lead to more Squashfs bashing.

Sorry, I didn't mean to be abusive. From first look, it appeared to do
everything that squashfs does, with less code, but you've made it clear
that there is need for both of them.
I would still expect axfs to replace cramfs for all practical purposes,
even though that was written by our Emperor Penguin ;-)

	Arnd <><
