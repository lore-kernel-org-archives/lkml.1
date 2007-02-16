Return-Path: <linux-kernel-owner+w=401wt.eu-S1946038AbXBPSuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946038AbXBPSuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945968AbXBPSuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:50:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946038AbXBPSuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:50:00 -0500
Date: Fri, 16 Feb 2007 10:37:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve Fox <drfickle@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1 - undefined reference to `delete_module' on x86
Message-Id: <20070216103725.fb288ab9.akpm@linux-foundation.org>
In-Reply-To: <1171646057.3039.10.camel@drfickle.rchland.ibm.com>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<1171646057.3039.10.camel@drfickle.rchland.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 11:14:17 -0600 Steve Fox <drfickle@linux.vnet.ibm.com> wrote:

> Full log at
> http://test.kernel.org/abat/71719/debug/test.log.0
> Config at
> http://test.kernel.org/abat/71719/build/dotconfig
> 
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> kernel/built-in.o(.text+0x1426a): In function `store_mod_unload':
> kernel/kmod.c:168: undefined reference to `delete_module'
> make: *** [.tmp_vmlinux1] Error 1
> 

Yes, sorry.  I believe Greg now has a replacement patch which fixes that up.

I think the workaround is CONFIG_MODULE_UNLOAD=y (or
CONFIG_MODULE_FORCE_UNLOAD=y).
