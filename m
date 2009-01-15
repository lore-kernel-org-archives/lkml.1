Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbZAOMLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbZAOMLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZAOMKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:10:50 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:4343 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbZAOMKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:10:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Js6N8x7ngUpcvYo6cloUExj1WipzCSw4CChViFLc7WbbRMEHQ16CdTwxkrqL3Pp7WF
         qRnMrkBOq1ovZJ0yMfYsiPqH96Zd1rCTLJglxOoe7G1vejTzwkuq+AGj3NQ2gIuIpjHU
         lS0S0bDrpmBe7J3jfCTLq3QqiX3ZCtHheqWDY=
Message-ID: <ea11fea30901150410g5eb66065lb1918ab0b2e14cac@mail.gmail.com>
Date: Thu, 15 Jan 2009 17:40:46 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Build warnings with tree in asm/boot.h & asm/setup.h
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a git tree synced to Linus' tree. During builds I am getting
lot build warnings like below. Perhaps someone can have a look.

Apologies if this is not the right mailing list for this.

/home/mkatiyar/personal/kernel/linux-2.6/usr/include/video/edid.h:4:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/video/sisfb.h:25:
include of <linux/types.h> is preferred over <asm/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/video/sisfb.h:78:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/video/uvesafb.h:5:
found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include (0 files)
  CHECK   include/asm (52 files)
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/boot.h:14:
leaks CONFIG_PHYSICAL to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/boot.h:15:
leaks CONFIG_PHYSICAL to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/boot.h:16:
leaks CONFIG_PHYSICAL to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/boot.h:18:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/e820.h:13:
leaks CONFIG_NODES to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/e820.h:27:
leaks CONFIG_EFI to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/e820.h:44:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/kvm.h:9:
include of <linux/types.h> is preferred over <asm/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/kvm.h:16:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/mce.h:7:
include of <linux/types.h> is preferred over <asm/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/mce.h:29:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/mtrr.h:61:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/prctl.h:9:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/prctl.h:10:
extern's make no sense in userspace
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/prctl.h:11:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/ptrace-abi.h:83:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/ptrace-abi.h:86:
include of <linux/types.h> is preferred over <asm/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/ptrace-abi.h:93:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/ptrace-abi.h:143:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:15:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:16:
extern's make no sense in userspace
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:17:
extern's make no sense in userspace
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:23:
extern's make no sense in userspace
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:24:
extern's make no sense in userspace
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:51:
extern's make no sense in userspace
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:52:
extern's make no sense in userspace
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/setup.h:54:
leaks CONFIG_PARAVIRT to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/sigcontext.h:5:
include of <linux/types.h> is preferred over <asm/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/sigcontext.h:24:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/sigcontext32.h:20:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/swab.h:4:
include of <linux/types.h> is preferred over <asm/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/swab.h:7:
found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/swab.h:10:
leaks CONFIG_X86 to userspace where it is not valid
/home/mkatiyar/personal/kernel/linux-2.6/usr/include/asm/swab.h:40:
leaks CONFIG_X86 to userspace where it is not valid


Thanks -
Manish
