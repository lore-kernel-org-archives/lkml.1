Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYJWOL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYJWOL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYJWOLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:11:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:13212 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYJWOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uBQ/QohL3oCMjsaobQx/EAswnMykxAY676n+HrWmTN0/wRV4oaG0TBbW+ZdTTbfDmx
         iO67q6GI/hakyRcFPc8ollacCfOgpG1AY9aQtIZtpVhUc2xdEhjDYoZ1k7eZUASF9Vjk
         kYsBKUotia3KdCeiRLrztbwPTnfDPWb5+Xck0=
Date: Thu, 23 Oct 2008 18:14:55 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       rui.p.m.sousa@gmail.com, mingo@elte.hu
Subject: linux-next: x86_64 UML broken
Message-ID: <20081023141455.GA1594@x200.localdomain>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023213637.eff9b414.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On um-x86_64-debug-y:

  SYMLINK arch/um/include/kern_constants.h
  SYMLINK arch/um/include/sysdep
make[2]: `arch/um/sys-x86_64/user-offsets.s' is up to date.
  Using /src/linux-1 as source for kernel
  GEN     /src/build/um-x86_64-debug-y/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/um/kernel/asm-offsets.s
In file included from /src/linux-1/include/linux/spinlock.h:90,
                 from /src/linux-1/include/linux/seqlock.h:29,
                 from /src/linux-1/include/linux/time.h:8,
                 from /src/linux-1/include/linux/timex.h:57,
                 from /src/linux-1/include/linux/sched.h:54,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from /src/linux-1/arch/um/kernel/asm-offsets.c:1:
/src/linux-1/include/linux/spinlock_up.h: In function '__raw_spin_lock_flags':
/src/linux-1/include/linux/spinlock_up.h:31: error: implicit declaration of function 'local_irq_save'
In file included from /src/linux-1/include/linux/sched.h:77,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from /src/linux-1/arch/um/kernel/asm-offsets.c:1:
/src/linux-1/include/linux/proportions.h: In function 'prop_inc_percpu':
/src/linux-1/include/linux/proportions.h:77: error: implicit declaration of function 'local_irq_restore'
make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2
