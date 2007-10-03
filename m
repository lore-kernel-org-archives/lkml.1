Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbXJCEY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbXJCEY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbXJCEYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:24:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:37254 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbXJCEYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pB9jSkpP6TUqN0MTtCKzJ//Cty2okmEVvYCdQflvI/mShiOw3HreWXUWJGAy3zCITvakfT8uSaSoY00qJdT6BRl3S/JMqHddTzbF3CIvOt434nuDKpjEM0iBw+ZcM2r0+718srOx99S8zuDbzrVqpUdjhVbUJPLFKC0iYKz8/ls=
Message-ID: <fdaac4d50710022124n73a025aay4a4ea6a569a8c691@mail.gmail.com>
Date: Wed, 3 Oct 2007 13:24:17 +0900
From: "Jun Koi" <junkoi2004@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: My kernel fails with kexec
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I have a kernel (which is not Linux kernel), and want to have it
worked with kexec. That means I want to get kexec boot my kernel.
Fortunately, kexec crashes when booting it. (with kexec -e command)

My suspect is that my kernel is not written to "support" kexec. So
could anybody tell me what is the requirement of a kernel, so it works
with kexec?

"kexec -e" spits out the below message in QEMU when booting my kernel. Any
hint where the problem lies, and on how to debug the problem?

Thanks,
Jun


(qemu) qemu: fatal: triple fault
EAX=00001500 EBX=001001f1 ECX=00000000 EDX=00004081
ESI=002ae8c0 EDI=002ac8c0 EBP=0000e098 ESP=00008ffe
EIP=00000d05 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0018 00000000 ffffffff 00cf9300
CS =4020 00040200 ffffffff 008f9f00
SS =4000 00040000 0000ffff 00009300
DS =0018 00000000 ffffffff 00cf9300
FS =0018 00000000 ffffffff 00cf9300
GS =0018 00000000 ffffffff 00cf9300
LDT=0000 00000000 00000000 00008000
TR =0080 c1fd7000 00002073 c10089fd
GDT=     0040a938 00000017
IDT=     c0000000 00000000
CR0=00000010 CR2=b7ed6200 CR3=00000000 CR4=00000000
CCS=00008000 CCD=00004000 CCO=SARL
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=f424000000000000 4012 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000
