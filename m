Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0CBWF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:05:56 -0500
Received: from xenotime.net ([72.52.64.118]:40055 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753208Ab0CBWFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:05:55 -0500
Message-ID: <4B8D8BC1.5000105@xenotime.net>
Date: Tue, 02 Mar 2010 14:05:53 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: werner@guyane.dyn-o-saur.com
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-git6 problem (compal-laptop)
References: <1267446083.16093@guyane.dyn-o-saur.com>
In-Reply-To: <1267446083.16093@guyane.dyn-o-saur.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/10 04:21, werner@guyane.dyn-o-saur.com wrote:
> before, these errors didn't occur
> ....
>   CC      arch/x86/lib/strstr_32.o
>   AS      arch/x86/lib/thunk_32.o
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 9 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `compal_rfkill_poll':
> compal-laptop.c:(.text+0x6317cf): undefined reference to `rfkill_set_hw_state'
> drivers/built-in.o: In function `compal_init':
> compal-laptop.c:(.init.text+0x3967d): undefined reference to `rfkill_alloc'
> compal-laptop.c:(.init.text+0x3968d): undefined reference to `rfkill_register'
> compal-laptop.c:(.init.text+0x396b2): undefined reference to `rfkill_alloc'
> compal-laptop.c:(.init.text+0x396c7): undefined reference to `rfkill_register'
> compal-laptop.c:(.init.text+0x396d7): undefined reference to `rfkill_destroy'
> compal-laptop.c:(.init.text+0x396e1): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.init.text+0x396eb): undefined reference to `rfkill_destroy'
> drivers/built-in.o: In function `compal_cleanup':
> compal-laptop.c:(.exit.text+0x6b4b): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.exit.text+0x6b55): undefined reference to `rfkill_destroy'
> compal-laptop.c:(.exit.text+0x6b5f): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.exit.text+0x6b69): undefined reference to `rfkill_destroy'
> make: [.tmp_vmlinux1] Error 1 (ignored)
>   KSYM    .tmp_kallsyms1.S
> nm: '.tmp_vmlinux1': No such file
> No valid symbol.
> make: [.tmp_kallsyms1.S] Error 1 (ignored)
>   AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
> drivers/built-in.o: In function `compal_rfkill_poll':
> compal-laptop.c:(.text+0x6317cf): undefined reference to `rfkill_set_hw_state'
> drivers/built-in.o: In function `compal_init':
> compal-laptop.c:(.init.text+0x3967d): undefined reference to `rfkill_alloc'
> compal-laptop.c:(.init.text+0x3968d): undefined reference to `rfkill_register'
> compal-laptop.c:(.init.text+0x396b2): undefined reference to `rfkill_alloc'
> compal-laptop.c:(.init.text+0x396c7): undefined reference to `rfkill_register'
> compal-laptop.c:(.init.text+0x396d7): undefined reference to `rfkill_destroy'
> compal-laptop.c:(.init.text+0x396e1): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.init.text+0x396eb): undefined reference to `rfkill_destroy'
> drivers/built-in.o: In function `compal_cleanup':
> compal-laptop.c:(.exit.text+0x6b4b): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.exit.text+0x6b55): undefined reference to `rfkill_destroy'
> compal-laptop.c:(.exit.text+0x6b5f): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.exit.text+0x6b69): undefined reference to `rfkill_destroy'
> make: [.tmp_vmlinux2] Error 1 (ignored)
>   KSYM    .tmp_kallsyms2.S
> nm: '.tmp_vmlinux2': No such file
> No valid symbol.
> make: [.tmp_kallsyms2.S] Error 1 (ignored)
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux
> drivers/built-in.o: In function `compal_rfkill_poll':
> compal-laptop.c:(.text+0x6317cf): undefined reference to `rfkill_set_hw_state'
> drivers/built-in.o: In function `compal_init':
> compal-laptop.c:(.init.text+0x3967d): undefined reference to `rfkill_alloc'
> compal-laptop.c:(.init.text+0x3968d): undefined reference to `rfkill_register'
> compal-laptop.c:(.init.text+0x396b2): undefined reference to `rfkill_alloc'
> compal-laptop.c:(.init.text+0x396c7): undefined reference to `rfkill_register'
> compal-laptop.c:(.init.text+0x396d7): undefined reference to `rfkill_destroy'
> compal-laptop.c:(.init.text+0x396e1): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.init.text+0x396eb): undefined reference to `rfkill_destroy'
> drivers/built-in.o: In function `compal_cleanup':
> compal-laptop.c:(.exit.text+0x6b4b): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.exit.text+0x6b55): undefined reference to `rfkill_destroy'
> compal-laptop.c:(.exit.text+0x6b5f): undefined reference to `rfkill_unregister'
> compal-laptop.c:(.exit.text+0x6b69): undefined reference to `rfkill_destroy'

Ingo posted a patch for this.  See  http://lkml.org/lkml/2010/3/2/153

-- 
~Randy
