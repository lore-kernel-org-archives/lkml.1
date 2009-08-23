Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZHWKyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZHWKyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 06:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZHWKyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 06:54:09 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:33429 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbZHWKyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 06:54:08 -0400
Message-ID: <4A911F93.5030905@free.fr>
Date: Sun, 23 Aug 2009 12:53:07 +0200
From: bernard pidoux <bpidoux@free.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: gfs2_mkdir : array subscript is above array bounds
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I observed the following warning when compiling 2.6.30.5 kernel

root@F6BVP-5 linux]# make
CHK include/linux/version.h
CHK include/linux/utsrelease.h
SYMLINK include/asm -> include/asm-x86
CALL scripts/checksyscalls.sh
CHK include/linux/compile.h
CC [M] fs/gfs2/ops_inode.o
fs/gfs2/ops_inode.c: In function ‘gfs2_mkdir’:
/usr/src/linux-2.6.30.5/arch/x86/include/asm/string_32.h:75: attention : 
array subscript is above array bounds
LD [M] fs/gfs2/gfs2.o
Kernel: arch/x86/boot/bzImage is ready (#2)

Bernard Pidoux

