Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYBKLT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYBKLT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYBKLTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:19:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:52866 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYBKLTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:19:50 -0500
Date: Mon, 11 Feb 2008 12:19:53 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: parisc - error: 'VMALLOC_START' undeclared...
Message-ID: <20080211111953.GA18652@ska.dandreoli.com>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in building 2.6.25-rc1:

  CC      arch/parisc/kernel/asm-offsets.s
In file included from include/asm/pgtable.h:13,
                 from arch/parisc/kernel/asm-offsets.c:36:
include/linux/mm.h: In function 'is_vmalloc_addr':
include/linux/mm.h:243: error: 'VMALLOC_START' undeclared (first use in this function)
include/linux/mm.h:243: error: (Each undeclared identifier is reported only once
include/linux/mm.h:243: error: for each function it appears in.)
include/linux/mm.h:243: error: 'VMALLOC_END' undeclared (first use in this function)
make[1]: *** [arch/parisc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

bisected to commit 9e2779fa281cfda13ac060753d674bbcaa23367e. it looks
like is_vmalloc_addr() did not arrive down to the parisc stuff.

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
