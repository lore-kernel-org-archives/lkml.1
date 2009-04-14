Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZDNPiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZDNPiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZDNPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:37:49 -0400
Received: from web65513.mail.ac4.yahoo.com ([76.13.9.57]:29335 "HELO
	web65513.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752178AbZDNPhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:37:47 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 11:37:47 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=Yt/RrPHp3f7NDAG3XPpBLfTgPpvymJVMg5iOwlUHqE6ov9J6kSooxrmfnaP1uOQaf72nDiIDEl9EZg1U/agbxZye2sbrteumycFCcIk88i9UDfBiwXuOTRa4Bk47KVhbq1THOpDQ7YXn7a3ftrnsMw66c+gFM67jJ86H6B9mw4M=;
Message-ID: <360384.56425.qm@web65513.mail.ac4.yahoo.com>
X-YMail-OSG: R89pDu0VM1k1g6KMiI82ErX0RgGNKicyBtYdnVoBp_8LECbIUoH9ILBTqndgzcOegaxOkZxaRpmUdF9ygTWWh_w_UX4Xxzf61gt9wFS0ORrTlN8iETNaaNRNIM_CNoOX7v8FmQ1fQYxgfcppONgHmgdlH8pvwuRPC98VmXgOMbiK7nB_oEavyB99Eum67GwAaLVnY.F_m5Z2QhKiJD5njDc4rX7httygNoterIx3sTV1d7YVuu51Ig9pI8rATfABrvhono0KDQ14Z5mVbqty04z8
X-Mailer: YahooMailWebService/0.7.289.1
Date: Tue, 14 Apr 2009 08:31:05 -0700 (PDT)
From: Jerry Wang <jerry18th@yahoo.com>
Reply-To: jerry18th@yahoo.com
Subject: linux 2.6.11.1 kernel cross-compiling errors
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am trying to cross-compile the linux 2.6.11.1 kernel on
i686 vm for ppc, and I've been getting the following
errors. Has anyone had this issue before?

Thanks,
Jerry 

> In file included from arch/ppc/kernel/asm-offsets.c:13:
> include/linux/sched.h: In function
> `arch_pick_mmap_layout':
> include/linux/sched.h:1174: error: `CONFIG_TASK_SIZE'
> undeclared (first use in this function)
> include/linux/sched.h:1174: error: (Each undeclared
> identifier is reported only once
> include/linux/sched.h:1174: error: for each function it
> appears in.)
> In file included from include/linux/mman.h:5,
>                  from arch/ppc/kernel/asm-offsets.c:19:
> include/linux/mm.h: In function `lowmem_page_address':
> include/linux/mm.h:437: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> In file included from arch/ppc/kernel/asm-offsets.c:21:
> include/asm/io.h: In function `virt_to_bus':
> include/asm/io.h:396: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> include/asm/io.h: In function `bus_to_virt':
> include/asm/io.h:407: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> include/asm/io.h: In function `virt_to_phys':
> include/asm/io.h:420: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> include/asm/io.h: In function `phys_to_virt':
> include/asm/io.h:429: error: `CONFIG_KERNEL_START'
> undeclared (first use in this function)
> arch/ppc/kernel/asm-offsets.c: In function `main':
> arch/ppc/kernel/asm-offsets.c:139: error:
> `CONFIG_TASK_SIZE' undeclared (first use in this
> function)
> make[1]: *** [arch/ppc/kernel/asm-offsets.s] Error 1
> make: *** [arch/ppc/kernel/asm-offsets.s] Error 2


      
