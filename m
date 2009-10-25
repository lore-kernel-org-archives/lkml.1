Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZJYV1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZJYV1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 17:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZJYV1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 17:27:19 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58721 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZJYV1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 17:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SKYhydFKK3S16at8XvltvXDTGucUZ3g6gjyoI/xS6K1uWwjqCRTopTNvPDtgrqjM1/
         81XaTjg1C/Fj4xaZI3GNNeoUgol+YDNCaKxseFUXsCaBsNdGihDHbTCEkyg9jAIIDwpe
         i4NJ/2XUdIR5B95IvG3XXF037JDht9q/JEqfY=
MIME-Version: 1.0
In-Reply-To: <20091025110617.GA6691@merkur.ravnborg.org>
References: <55e03a0a0910242038x5656e9c0ve28bb28023dc1432@mail.gmail.com>
	 <20091025110617.GA6691@merkur.ravnborg.org>
Date: Sun, 25 Oct 2009 17:27:21 -0400
Message-ID: <55e03a0a0910251427q5f3b4448s2b487277aa121e06@mail.gmail.com>
Subject: Re: Compiling 2.6.31/31.5
From: Alex <mysqlstudent@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had previously sent an email describing problems I'm having
compiling 2.6.31, and I've worked with it a bit more, but still having
problems. I'm having difficulty compiling 2.6.31 and 2.6.31.5 on x86
with gcc-3.4.4 and binutils-2.20.51.0.2. I'm also using glibc-2.3.6.

 AS      arch/x86/lib/thunk_32.o
 CC      arch/x86/lib/usercopy_32.o
 AR      arch/x86/lib/lib.a
 LD      vmlinux.o
 MODPOST vmlinux.o
 GEN     .version
 CHK     include/linux/compile.h
 UPD     include/linux/compile.h
 CC      init/version.o
 LD      init/built-in.o
 LD      .tmp_vmlinux1
drivers/built-in.o: In function `con_init':
vt.c:(.init.text+0x3c5b): undefined reference to `.L1446'
make: *** [.tmp_vmlinux1] Error 1

My .config file is generated from "make defconfig".

I've seen a few references to this searching, but all the solutions
didn't apply or didn't work. What could I be doing wrong? Could this
be a problem with my development tools?

Ideas greatly appreciated.

Thanks,
Alex
