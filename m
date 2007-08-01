Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbXHAIWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbXHAIWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbXHAIWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:22:17 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:56953 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbXHAIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:22:12 -0400
Subject: build error on powerpc for 2.6.23-rc1-mm2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Build V80_M5_05202007 May 20, 2007
Message-ID: <OFFC0F3DEC.2DEDE1A8-ON6525732A.002DB5E7-6525732A.002DEF2C@in.ibm.com>
From: Rishikesh K Rajak <risrajak@in.ibm.com>
Date: Wed, 1 Aug 2007 13:52:05 +0530
X-MIMETrack: Serialize by Router on d23ml063/23/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 01/08/2007 13:52:06
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

I am getting following error on powerpc almost for allyesconfig,
allmodconfig.

Error produced:

PowerPC: allmodconfig,allyesconfig

  CC      arch/powerpc/mm/tlb_64.o
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:
 Assembler messages:
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:27:
 Error: Unrecognized opcode: `mtocrf'
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:138:
 Error: Unrecognized opcode: `mtocrf'
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:153:
 Error: Unrecognized opcode: `mtocrf'
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:
 Assembler messages:
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:15:
 Error: Unrecognized opcode: `mtocrf'
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:131:
 Error: Unrecognized opcode: `mtocrf'
/home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:146:
 Error: Unrecognized opcode: `mtocrf'
make[2]: *** [arch/powerpc/lib/memcpy_64.o] Error 1
make[2]: *** Waiting for unfinished jobs....
  CC      arch/powerpc/sysdev/mpic_u3msi.o
make[2]: *** [arch/powerpc/lib/copyuser_64.o] Error 1
make[1]: *** [arch/powerpc/lib] Error 2


Thanks
Rishi Kesh K Rajak

IBM-ISL,Manyata Embassy Business Park,
Block D2, Nagawara Ring Road,
Nagawara, bangalore-560045
+91-80-40255044
Mob: +91-9986019642
FAX: +91-80-25436902

