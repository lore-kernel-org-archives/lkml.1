Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZDPPXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZDPPXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZDPPXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:23:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39231 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZDPPXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:23:34 -0400
Date: Thu, 16 Apr 2009 10:23:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/30] cr: extend arch_setup_additional_pages()
Message-ID: <20090416152327.GA19077@us.ibm.com>
References: <20090410023739.GR27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023739.GR27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> Add "start" argument, it will be used to map vDSO to exactly same place
> on restart(2).
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

IIRC the first (bprm) argument is actually completely unused.  So in my
version of this patch (in mid-march) I dropped that argument.

> ---
> 
>  arch/powerpc/include/asm/elf.h     |    1 +
>  arch/powerpc/kernel/vdso.c         |    2 +-
>  arch/s390/include/asm/elf.h        |    2 +-
>  arch/s390/kernel/vdso.c            |    2 +-
>  arch/sh/include/asm/elf.h          |    1 +
>  arch/sh/kernel/vsyscall/vsyscall.c |    2 +-
>  arch/x86/include/asm/elf.h         |    3 ++-
>  arch/x86/vdso/vdso32-setup.c       |    2 +-

You didn't get arch/x86/vdso/vma.c.

But otherwise:

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge
