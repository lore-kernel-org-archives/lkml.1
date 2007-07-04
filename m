Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbXGDCxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbXGDCxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 22:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXGDCx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 22:53:29 -0400
Received: from web54507.mail.re2.yahoo.com ([206.190.49.157]:32676 "HELO
	web54507.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754294AbXGDCx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 22:53:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ziRGlcmZXrGwne0UI++JXCq6Ypj01ie7KbzgrB5Kvhw5YY5vXRQBfq/JRzBCGvvltOVn6wjNfpSVIro6zQG+WHUSvBKXvWLPwyaaxu0ieL0LwFkX7ukH+a4yLbH2k5lSIWAV2ykBZWYlDp0sUVVNDDuETPm+I4zE/fG/Mt8wyII=;
X-YMail-OSG: Y9OI.mwVM1mYq0rmbqxgYrVrNJF..IYNPGF8E6TfyFjJlIFPgBauVFuq5EBZTeXfm3.S8GXmluIvQCysvfHNUmJg9cp5WcQe.DZPvQJXDOr1SMkjUQyGPCNIng--
Date: Wed, 4 Jul 2007 11:53:27 +0900 (KST)
From: yong Jung <yong_jk@yahoo.com>
Subject: LZMA error on 2.6.16
To: linux-kernel@vger.kernel.org
Cc: =?euc-kr?q?=BC=D5=C1=F6=BF=AC?= <jyson@datatek.co.kr>, kskim@datatek.co.kr
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Message-ID: <683.29137.qm@web54507.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
.
While compiling kernel on FC7, kernel-2.6.16 with LZMA
compression utilily, we got the following compile
error message. I already applied two
pathes,lzma-init-2.6.16.patch5 ,
lzma-vmlinuz-2.6.16.patch5.
And during compressing vmlinuz, I meet an error like
the following messages. 
I also tried this on kernle-2.6.20, but got the same
result.
Could you please give me some tips ?

..... 
AR arch/i386/lib/lib.a 
GEN .version 
CHK include/linux/compile.h 
UPD include/linux/compile.h 
CC init/version.o 
LD init/built-in.o 
LD .tmp_vmlinux1 
KSYM .tmp_kallsyms1.S 
AS .tmp_kallsyms1.o 
LD .tmp_vmlinux2 
KSYM .tmp_kallsyms2.S 
AS .tmp_kallsyms2.o 
LD .tmp_vmlinux3 
KSYM .tmp_kallsyms3.S 
AS .tmp_kallsyms3.o 
LD vmlinux 
SYSMAP System.map 
SYSMAP .tmp_System.map 
AS arch/i386/boot/bootsect.o 
LD arch/i386/boot/bootsect 
AS arch/i386/boot/setup.o 
LD arch/i386/boot/setup 
AS arch/i386/boot/compressed/head.o 
CC arch/i386/boot/compressed/lzma_misc.o 
OBJCOPY arch/i386/boot/compressed/vmlinux.bin 
LZMA arch/i386/boot/compressed/vmlinux.bin.lzma 
make[2]: ***
[arch/i386/boot/compressed/vmlinux.bin.lzma] Error 1 
make[1]: *** [arch/i386/boot/compressed/vmlinux] Error
2 
make: *** [bzImage] Error 2 
[root@localhost linux-2.6.16]#  
.
Warm regards,
Nobel



      ________________________________________________________ 
180도 달라진 야후! 메일 - 탄탄한 보안! 새로운 야후! 메일의 ‘안전주소'기능으로 스팸을 차단하세요.
http://kr.content.mail.yahoo.com/cgland
