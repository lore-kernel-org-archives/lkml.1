Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYCKE7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYCKE7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYCKE7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:59:24 -0400
Received: from mail.daxal.com ([66.221.37.219]:48081 "EHLO mail.daxal.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYCKE7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:59:23 -0400
X-Greylist: delayed 1446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 00:59:23 EDT
From: "Scott Edwards" <lkml@foss.daxal.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.3 ARCH=um FTBFS c/o undefined reference to `i386_mmap_check'
Date: Mon, 10 Mar 2008 23:35:16 -0500
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="utf-8,iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <20080311043516.4D92F320001@mail.daxal.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm attempting to build a user mode linux kernel with some grsec features 
(no PaX, apparently incompatible)  I'm using 2.6.24.3 and 
grsecurity-2.1.11-2.6.24.3-200803031942.patch.gz  This is built on a Debian 
Etch host.  I have compiled linux-2.6.25-rc3-mm1 which also seems to run 
without complaint. 

Here's a partial log of the last lines before it fails. 

LD vmlinux.o
MODPOST vmlinux.o
GEN .version
CHK include/linux/compile.h
UPD include/linux/compile.h
CC init/version.o
LD init/built-in.o
LD vmlinux
mm/built-in.o: In function `do_mmap_pgoff':
(.text+0xe35d): undefined reference to `i386_mmap_check'
mm/built-in.o: In function `do_brk':
(.text+0xf3be): undefined reference to `i386_mmap_check'
collect2: ld returned 1 exit status
SYSMAP System.map
nm: 'vmlinux': No such file
make: *** [vmlinux] Error 1
Script done, file is 
../uml.linux-2.6.24.3-scrub-08.3b7a66a4-1774-448b-8ac3-65cb88c18950.txt
supaplex@armada: uml.linux-2.6.24.3-scrub-08$ ls -A
arch drivers kernel Module.symvers sound
block fs lib net System.map
.config .gitignore localversion-grsec .old_version .tmp_versions
.config.old grsecurity .mailmap README usr
COPYING include MAINTAINERS REPORTING-BUGS .version
CREDITS init Makefile samples .vmlinux.cmd
crypto ipc .missing-syscalls.d scripts vmlinux.o
Documentation Kbuild mm security .vmlinux.o.cmd 

Thanks, 


Scott

