Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZGAHSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZGAHSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZGAHSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:18:18 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:39173 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZGAHSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j425XS8OFDme5fcxog9jYCE0PXfG/l1xM7TPWKyaiHQHSb56+wBjvskL8qZwaevzp8
         qRh7ipHSDdjSkQts09qzHR/FxqmCXjI+nOg52RZiGqeSGWCLJqPUcNpfeUC1SZCnTtcs
         VBThJDZ6NpjIgHFzbLAWUDxG85vqMPdaJUjz4=
Date: Wed, 1 Jul 2009 15:20:27 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, dhowells@redhat.com
Subject: Re: [PATCH] Fix the multithread program core thread message error
Message-ID: <20090701072027.GE6076@cr0.nay.redhat.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com> <20090701005437.GA5856@cr0.nay.redhat.com> <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com> <20090701045102.GA6076@cr0.nay.redhat.com> <daef60380906302321n681b8092k32c468ae281f4fbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daef60380906302321n681b8092k32c468ae281f4fbb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 02:21:37PM +0800, Hui Zhu wrote:
>Thanks for your help, Amerigo.

You're welcome.

>
>Hui
>
>---
> elfcore.h |    2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
>index 7605c5e..03ec167 100644
>--- a/include/linux/elfcore.h
>+++ b/include/linux/elfcore.h
>@@ -125,6 +125,8 @@ static inline int elf_core_copy_task_regs(struct
>task_struct *t, elf_gregset_t*
> #ifdef ELF_CORE_COPY_TASK_REGS
>
>       return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>+#else
>+       elf_core_copy_regs(elfregs, task_pt_regs(t));
> #endif
>       return 0;
> }

Your email client eats tabs. :) Can you fix your email client
or resend it with a tool like git send-email?

Thanks.
