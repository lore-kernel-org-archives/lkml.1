Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbXEaUn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbXEaUn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXEaUnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:43:22 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4624 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbXEaUnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:43:21 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, Arnd Bergmann <arndb@de.ibm.com>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 22:43:18 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705312243.18724.m.kozlowski@tuxland.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

	This is from iMac G3. The spufs_mem_mmap_fault() code looks bad
in arch/powerpc/platforms/cell/spufs/file.c but somehow I'm unable to find
the patch to blame hmm.

arch/powerpc/platforms/cell/spufs/file.c: In function 'spufs_mem_mmap_fault':
arch/powerpc/platforms/cell/spufs/file.c:122: error: 'address' undeclared (first use in this function)
arch/powerpc/platforms/cell/spufs/file.c:122: error: (Each undeclared identifier is reported only once
arch/powerpc/platforms/cell/spufs/file.c:122: error: for each function it appears in.)
arch/powerpc/platforms/cell/spufs/file.c:141: error: expected ';' before 'if'
arch/powerpc/platforms/cell/spufs/file.c:122: warning: unused variable 'addr0'
make[3]: *** [arch/powerpc/platforms/cell/spufs/file.o] Blad 1
make[2]: *** [arch/powerpc/platforms/cell/spufs] Blad 2
make[1]: *** [arch/powerpc/platforms/cell] Blad 2

Regards,

	Mariusz
