Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYJQRqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYJQRqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYJQRqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:46:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44170 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbYJQRqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:46:40 -0400
Subject: 2.6.27-git7 compile error (ppc)
From: Badari Pulavarty <pbadari@us.ibm.com>
To: LinuxPPC-dev <linuxppc-dev@ozlabs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 10:47:14 -0700
Message-Id: <1224265634.15582.3.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this following compile error on my ppc box.

Let me know if its a known issue. Otherwise, I can figure out
whats happening.

Thanks,
Badari

  CC      arch/powerpc/mm/slb.o
In file included from /usr/src/linux-2.6.27/arch/powerpc/include/asm/mmu-hash64.h:16,
                 from /usr/src/linux-2.6.27/arch/powerpc/include/asm/mmu.h:7,
                 from /usr/src/linux-2.6.27/arch/powerpc/include/asm/pgtable.h:7,
                 from arch/powerpc/mm/slb.c:19:
/usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: error: parse error before "memstart_addr"
/usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: warning: type defaults to `int' in declaration of `memstart_addr'
/usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:76: warning: data definition has no type or storage class
/usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: error: parse error before "kernstart_addr"
/usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: warning: type defaults to `int' in declaration of `kernstart_addr'
/usr/src/linux-2.6.27/arch/powerpc/include/asm/page.h:77: warning: data definition has no type or storage class
  AS      arch/powerpc/lib/string.o
  CC      arch/powerpc/lib/alloc.o
  CALL    arch/powerpc/kernel/systbl_chk.sh
  CC      arch/powerpc/kernel/sysfs.o
make[1]: *** [arch/powerpc/mm/slb.o] Error 1
make: *** [arch/powerpc/mm] Error 2
make: *** Waiting for unfinished jobs....


