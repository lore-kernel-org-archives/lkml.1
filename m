Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXAZQqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXAZQqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030789AbXAZQqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:46:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:5825 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030776AbXAZQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=SU+X+AJgWQ9UByQ8Di7PsMxVcuOyQVqzcSgaULD8tF3dAHcX2w+HZXxYWnlEm4hK4GevUTf39OLiDmuZvKhNxsvsloS4+cFEFWcVWK/3XbcMHGx05d4QO6AI4TONrrvGZ26BM82amlRCWO6NNTcj6Hl9HmGk3g7Vi4iDIzTyd18=
Message-ID: <45BA3060.3060007@googlemail.com>
Date: Fri, 26 Jan 2007 17:46:24 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>
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
> 

Yet another build error

In file included from arch/i386/kernel/process.c:56:
include/asm/debugreg.h:84: error: expected identifier or '(' before '{' token
make[1]: *** [arch/i386/kernel/process.o] Error 1
make: *** [arch/i386/kernel] Error 2

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/include/asm-i386/debugreg.h	2007-01-26 16:47:41.000000000 +0100
+++ linux-work/include/asm-i386/debugreg.h	2007-01-26 17:39:58.000000000 +0100
@@ -80,7 +80,7 @@ extern int enable_debugreg(unsigned long

 #else

-static inline void set_process_debugreg7(unsigned long new_dr7);
+static inline void set_process_debugreg7(unsigned long new_dr7)
 {
 	set_debugreg(new_dr7, 7);
 }
