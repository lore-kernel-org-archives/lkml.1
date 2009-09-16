Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZIPLmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZIPLmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZIPLmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:42:53 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:53189 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZIPLmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=clrmI1i4j5MI96OcrVyrCTHC9EzWAm9+vmzrkKiFQz9QOsauvpK8B68cIqmgDt3Kvs
         u01YP6ynZFTbeRvycMoBWuoOx1SNVm2jDW43MKgzLKkYHXDtRiZnW7ok2FR5rklF0ZSq
         FI6U3RvrX9+UzoDgHhN2oe0ScCYR2Vv6P1pjM=
MIME-Version: 1.0
Date: Wed, 16 Sep 2009 17:12:56 +0530
Message-ID: <55f89e6d0909160442i18e0d7e1gba4b7a539598bb1e@mail.gmail.com>
Subject: linux-2.6.31 compilation error : include/trace/events/kmem.h:47: 
	undefined reference to `.L1443'
From: Ananth M <mekaananth@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

    I downloaded the latest stable kernel : i.e linux-2.6.31 today and
tried to compile the kernel in my desktop, with default configuaration
(not changed any config values )
   My desktop machine has : RHEL 4 with GCC version 3.4.6

    I am getting the following error , during linking

 CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o(.init.text+0x3d80): In function `con_init':
include/trace/events/kmem.h:47: undefined reference to `.L1443'
make: *** [.tmp_vmlinux1] Error 1




    I noticed ( through mailing list ) that the same problem was
observed by some other developers and they planned to compile without
tracer option. I also disabled the tracer option and compiled, but
still the same error exists.
    Can any one help me on this?

Thank you
Regards
Ananth
