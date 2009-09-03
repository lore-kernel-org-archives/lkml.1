Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZICVZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZICVZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbZICVZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:25:45 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:10427 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbZICVZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:25:44 -0400
X-IronPort-AV: E=Sophos;i="4.44,327,1249272000"; 
   d="scan'208";a="5914870"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: asm-generic update candidates?
Date: Thu, 3 Sep 2009 17:29:52 -0400
User-Agent: KMail/1.9.5
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200909031729.52538.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 03 Sep 2009 21:25:46.0818 (UTC) FILETIME=[19F23A20:01CA2CDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd:

I was reviewing some files in ./arch/blackfin/include for missing copyrights, 
and while tracking things down I noticed there were still some likely 
candidates for inclusion in asm-generic...

All seem to be the same file:

md5sum:
5b6b31d728ed2ed0df73c56676fdc68f  blackfin/include/asm/fb.h
5b6b31d728ed2ed0df73c56676fdc68f  cris/include/asm/fb.h
5b6b31d728ed2ed0df73c56676fdc68f  frv/include/asm/fb.h
5b6b31d728ed2ed0df73c56676fdc68f  h8300/include/asm/fb.h
5b6b31d728ed2ed0df73c56676fdc68f  s390/include/asm/fb.h
5b6b31d728ed2ed0df73c56676fdc68f  xtensa/include/asm/fb.h

e31d052cbba4f417ba2158a41b0d8709  arm/include/asm/fb.h
e31d052cbba4f417ba2158a41b0d8709  m32r/include/asm/fb.h
e31d052cbba4f417ba2158a41b0d8709  sh/include/asm/fb.h

Mostly the same:
 mn10300/include/asm/shmparam.h
 frv/include/asm/shmparam.h
 m68k/include/asm/shmparam.h
 h8300/include/asm/shmparam.h
 alpha/include/asm/shmparam.h
 x86/include/asm/shmparam.h
 m32r/include/asm/shmparam.h
 avr32/include/asm/shmparam.h
 powerpc/include/asm/shmparam.h
 blackfin/include/asm/shmparam.h


All the same:
frv/include/asm/ucontext.h
h8300/include/asm/ucontext.h
avr32/include/asm/ucontext.h
m32r/include/asm/ucontext.h
cris/include/asm/ucontext.h
alpha/include/asm/ucontext.h
mips/include/asm/ucontext.h
microblaze/include/asm/ucontext.h
mn10300/include/asm/ucontext.h
blackfin/include/asm/ucontext.h

There seems to be lots of similarities in
 */include/asm/types.h
 */include/asm/kmap_types.h
 */include/asm/termios.h
 */include/asm/socket.h
 */include/asm/param.h
 */include/asm/signal.h (but not all)
 */include/asm/posix_types.h
 */include/asm/termbits.h
 */include/asm/segment.h
 */include/asm/auxvec.h
 */include/asm/shmbuf.h
 */include/asm/spinlock_types.h

Do you keep a list somewhere?

Thanks



