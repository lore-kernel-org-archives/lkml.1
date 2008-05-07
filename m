Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbYEGXnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbYEGXnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYEGXnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:43:37 -0400
Received: from simmts5-srv.bellnexxia.net ([206.47.199.163]:39989 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYEGXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:43:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQBAJ/bIUicIsTo/2dsb2JhbAAIim6ifQ
Message-ID: <48223EA4.4010306@gmail.com>
Date: Wed, 07 May 2008 20:43:32 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "Linux Kernel Mailing List \\" <linux-kernel@vger.kernel.org>
Subject: Section mismatch warnings with current mainline git
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Is this something people are interested in seeing?


WARNING: vmlinux.o(.text+0x1422b): Section mismatch in reference from 
the function set_pte_phys() to the function .init.text:spp_getpage()
The function set_pte_phys() references
the function __init spp_getpage().
This is often because set_pte_phys lacks a __init
annotation or the annotation of spp_getpage is wrong.

WARNING: vmlinux.o(.text+0x1429a): Section mismatch in reference from 
the function set_pte_phys() to the function .init.text:spp_getpage()
The function set_pte_phys() references
the function __init spp_getpage().
This is often because set_pte_phys lacks a __init
annotation or the annotation of spp_getpage is wrong.

WARNING: vmlinux.o(.text+0x17c72): Section mismatch in reference from 
the function arch_setup_additional_pages() to the variable 
.init.data:vdso_end
The function arch_setup_additional_pages() references
the variable __initdata vdso_end.
This is often because arch_setup_additional_pages lacks a __initdata
annotation or the annotation of vdso_end is wrong.

WARNING: vmlinux.o(.text+0x17c79): Section mismatch in reference from 
the function arch_setup_additional_pages() to the variable 
.init.data:vdso_start
The function arch_setup_additional_pages() references
the variable __initdata vdso_start.
This is often because arch_setup_additional_pages lacks a __initdata
annotation or the annotation of vdso_start is wrong.

WARNING: vmlinux.o(.cpuinit.text+0x2497): Section mismatch in reference 
from the function uv_cpu_init() to the function .init.text:uv_system_init()
The function __cpuinit uv_cpu_init() references
a function __init uv_system_init().
If uv_system_init is only used by uv_cpu_init then
annotate uv_system_init with a matching annotation.

-- 
Kevin Winchester
