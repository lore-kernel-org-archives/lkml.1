Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbXIEIku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbXIEIku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 04:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbXIEIkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 04:40:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:49531 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbXIEIkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 04:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Qc/D98mXDNVkWb6ClslLvcBhQuuWBzs9eWHN1qpaVhBh2O5BlN4gT+K+S8Efj6qW1BQqh2Yu5nakIWOWMXLEtaDvNFfK+/iGPTO4nBia71nc7+fzkAfAOIa6NEso7HhquU4r3uSfG7e6E8MT/LFNbABMTQyTTl0OjeaSQmcqndY=
Message-ID: <3f9a31f40709050140p698c37e3q403e2d1cadca1cf@mail.gmail.com>
Date: Wed, 5 Sep 2007 14:10:41 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: _syscall0 exists or obsolete in 2.6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am trying to add syscall in include/asm/unistd.h:

static inline _syscall0(int,my_sys_call);

But I am getting following errors :

  AS      arch/arm/kernel/entry-common.o
include/asm/unistd.h: Assembler messages:
include/asm/unistd.h:622: Error: bad instruction `static inline int
my_sys_call(void){register long __res_r0 __asm__("r0")'
include/asm/unistd.h:622: Error: bad instruction `long __res'
include/asm/unistd.h:622: Error: bad instruction `__asm__
__volatile__("swi\t""(0x900000+322)""":"=r"(__res_r0)::"memory")'
include/asm/unistd.h:622: Error: bad instruction `do {if((unsigned
long)(__res)>=(unsigned long)(-129)){errno=-(__res)'
include/asm/unistd.h:622: Error: junk at end of line, first
unrecognized character is `}'
include/asm/unistd.h:622: Error: junk at end of line, first
unrecognized character is `}'
include/asm/unistd.h:622: Error: junk at end of line, first
unrecognized character is `}'
make[1]: *** [arch/arm/kernel/entry-common.o] Error 1
make: *** [arch/arm/kernel] Error 2


This was working in older versions.

I am curious _syscall0 still exists or obsolete in 2.6 linux.

And I have noticed even if I commented _syscall0 macro, I do not get
any errors so no body is using it , then why _syscall0 is in kernel
header files and what is the substitute of _syscall0.

Thanks for help,

Jaswinder Singh.
