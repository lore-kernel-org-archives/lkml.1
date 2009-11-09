Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbZKICjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbZKICjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZKICjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:39:03 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40090 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZKICjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:39:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bXj8LrWmEZ3Dp9falcLvECVaM58dh8HmQAFqnNiNX8e4cSD0dG+6wfrIXxKvcg+S/o
         GmxSPwglQ3XRO+QkDib8AHQ+DG3Y0z9PVwedkXnTrEfsWp/i/4BM6X/PLOlXGaRRWzqU
         hci4DK83jh/ViVKeVrffICi+x2ngwtMBdQq4o=
MIME-Version: 1.0
Date: Sun, 8 Nov 2009 21:39:06 -0500
Message-ID: <55e03a0a0911081839h335e6ceeg977faef9c5e26a30@mail.gmail.com>
Subject: 2.6.32-rc6-git3 paravirt compile problems
From: Alex <mysqlstudent@gmail.com>
To: kvm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using glibc-2.6.3, gcc-3.4.4 and having problems compiling
2.6.32-rc6-git3 when selecting CONFIG_PARAVIRT_GUEST. This affects
both XEN and KVM options, or each indivdually.

  CC      init/main.o
/usr/src/linux-2.6.32-rc6-git3/arch/x86/include/asm/paravirt.h: In
function `start_kernel':
/usr/src/linux-2.6.32-rc6-git3/arch/x86/include/asm/paravirt.h:853:
warning: asm operand 2 probably doesn't match constraints
/usr/src/linux-2.6.32-rc6-git3/arch/x86/include/asm/paravirt.h:853:
warning: asm operand 2 probably doesn't match constraints
/usr/src/linux-2.6.32-rc6-git3/arch/x86/include/asm/paravirt.h:858:
warning: asm operand 2 probably doesn't match constraints
/usr/src/linux-2.6.32-rc6-git3/arch/x86/include/asm/paravirt.h:853:
error: impossible constraint in `asm'
/usr/src/linux-2.6.32-rc6-git3/arch/x86/include/asm/paravirt.h:853:
error: impossible constraint in `asm'
/usr/src/linux-2.6.32-rc6-git3/arch/x86/include/asm/paravirt.h:858:
error: impossible constraint in `asm'
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

I've seen many references to this same error with older versions of
gcc going back quite a bit. Am I doing something wrong, or has this
problem not yet been addressed?

Is there something I can do to properly configure KVM on later kernels
with gcc-3.4.4, or would I be advised to upgrade?

Thanks,
Alex
