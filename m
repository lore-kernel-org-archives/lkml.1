Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZJZRFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZJZRFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZJZRFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:05:12 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:29428 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZJZRFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:05:11 -0400
Date: Mon, 26 Oct 2009 10:00:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SHMEM question
Message-Id: <20091026100042.07ac281e.randy.dunlap@oracle.com>
In-Reply-To: <200910261159.04995.gene.heskett@verizon.net>
References: <200910261159.04995.gene.heskett@verizon.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AE5D6C8.001C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 11:59:04 -0400 Gene Heskett wrote:

> Greetings;
> 
> fedora F10 system, quad core phenom, 4GB ram, ASUS M2N-SLI Deluxe mobo
> kernel-2.6.32-rc5, uptime 2d 11:27 at the moment, and the system feels good.
> 
> rkhunter sent me an email this morning complaining about a data file in 
> /dev/shm.
> 
> On looking at it:
> [root@coyote Download]# ls -l /dev/shm
> total 28
> -rw-r----- 1 root root     4096 2009-10-25 12:09 mono.10594
> -r-------- 1 root root 67108904 2009-10-24 00:28 pulse-shm-3880918577
> -rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_ReadPrefs_root
> -rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_REL_root
> -rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_WritePrefs_root
> 
> On grepping for SHM in the .config, I find SHMEM set to y, but about an hours 
> worth of wandering around in a 'make xconfig' has failed to actually find it.

In xconfig, you can use /f to search for kconfig symbols.

SHMEM is under the General Setup menu (on x86), then under the
Configure standard kernel features (for small systems)
menu (i.e., EMBEDDED, so only shows up when EMBEDDED is enabled).


> That pulse-shm-3880918577 file at over 67 megabytes is all $00 till $04000000 
> into it, then there is 6 non-zero bytes and the rest is back to all balls.
> 
> Is this some indicator of a new rootkit or WTF?
> 
> It was the mono.10594 file that rkhunter-1.3.4 was concerned about.  I, since 
> I can't make a mental connection between SHMEM and /dev/shm, am concerned 
> about that whole tree of data which seems totally out of place in the /dev 
> tree.
> 
> I hate to be a pest but Many Thanks for any enlightenment on this.

Sorry, no idea about that.

---
~Randy
