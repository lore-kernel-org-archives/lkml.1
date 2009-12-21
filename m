Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZLUJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZLUJHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZLUJHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:07:32 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44452 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZLUJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:07:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not provably correct
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <0io307-9ti.ln1@news.researchut.com>
References: <0io307-9ti.ln1@news.researchut.com>
Message-Id: <20091221180537.089C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 21 Dec 2009 18:07:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is triggered if using the 'allyesconfig' target.
> 
> A similar issue was this: 2886a8bdfa007053b414ab01741a98c18c376a85
> 
> 
> debian-build:/tmp/all-yes-config/2.6.33-rc1# make deb-pkg
> make KBUILD_SRC=                                         
>   CHK     include/linux/version.h                        
>   CHK     include/generated/utsrelease.h                 
>   CALL    scripts/checksyscalls.sh                       
>   CHK     include/generated/compile.h                    
>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   LD      arch/x86/built-in.o
>   CC      mm/migrate.o
> In file included from /tmp/all-yes-config/2.6.33-
> rc1/arch/x86/include/asm/uaccess.h:571,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:6,
>                  from include/linux/pagemap.h:10,
>                  from include/linux/mempolicy.h:62,
>                  from include/linux/migrate.h:5,
>                  from mm/migrate.c:15:
> In function ‘copy_from_user’,
>     inlined from ‘do_pages_stat’ at mm/migrate.c:1009:
> /tmp/all-yes-config/2.6.33-rc1/arch/x86/include/asm/uaccess_32.h:213: error: 
> call to ‘copy_from_user_overflow’ declared with attribute error: 
> copy_from_user() buffer size is not provably correct

afaik, ingo already queued this fix.
please wait (very) few days.

thanks.




> make[3]: *** [mm/migrate.o] Error 1
> make[2]: *** [mm] Error 2
> make[1]: *** [deb-pkg] Error 2
> make: *** [deb-pkg] Error 2
> 
> 
> Regards,
> Ritesh
> -- 
> Given the large number of mailing lists I follow, I request you to CC me
> in replies for quicker response
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



