Return-Path: <linux-kernel-owner+w=401wt.eu-S1161064AbXAZRaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161064AbXAZRaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161066AbXAZRaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:30:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:62086 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161072AbXAZRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:30:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Bk7lliDsjdhsQzlEw0JR7Hr0oHBuJOzWoZmoLkPogCU0Tylre6nLgOW+fn07x1s/gBfFdXAF1b1ZoNYp+V0oIh8ZKwPAK9gP5jREBo/ntb3tChAo/EkWhXEdGVtdLgf7o6bwsdGyX9aFoJ70pbwdRzabfVi74pVMJbrhByVkRDw=
Message-ID: <45BA3A8C.5020802@googlemail.com>
Date: Fri, 26 Jan 2007 18:29:48 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, clg@fr.ibm.com,
       herbert@13thfloor.at, oleg@tv-sign.ru, daniel@hozac.com
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@osdl.org napisa³(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz

kernel/exit.c: In function 'do_exit':
kernel/exit.c:941: warning: implicit declaration of function 'preexit_task_namespaces'
kernel/exit.c:941: warning: assignment makes pointer from integer without a cast
kernel/exit.c:943: error: too many arguments to function 'exit_task_namespaces'
make[1]: *** [kernel/exit.o] Error 1
make: *** [kernel] Error 2

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/include/linux/nsproxy.h	2007-01-26 17:40:29.000000000 +0100
+++ linux-work/include/linux/nsproxy.h	2007-01-26 18:23:19.000000000 +0100
@@ -51,6 +51,6 @@ static inline void put_and_finalize_nspr
 	finalize_put_nsproxy(put_nsproxy(ns));
 }

-extern void exit_task_namespaces(struct task_struct *p);
+extern void exit_task_namespaces(struct task_struct *p, struct nsproxy *ns);

 #endif


