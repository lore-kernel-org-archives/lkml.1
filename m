Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYAHHsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYAHHsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbYAHHsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:48:18 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:57607 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbYAHHsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:48:17 -0500
Date: Tue, 8 Jan 2008 08:48:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bunk@kernel.org,
       clameter@sgi.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build-Failure at
 __you_cannot_kmalloc_that_much
Message-ID: <20080108084813.7e08f59b@hyperion.delvare>
In-Reply-To: <478200A4.4090707@linux.vnet.ibm.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<478200A4.4090707@linux.vnet.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jan 2008 16:06:20 +0530, Kamalesh Babulal wrote:
> The defconfig make fails on x86_64 (AMD box) with following error
> 
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o(.init.text+0x8d76): In function `dmi_id_init':
> : undefined reference to `__you_cannot_kmalloc_that_much'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> # gcc --version
> gcc (GCC) 3.2.3 20030502 (Red Hat Linux 3.2.3-59)
> 
> This was reported by Adrian Bunk http://lkml.org/lkml/2007/12/1/39

And by myself long before that...
http://lkml.org/lkml/2007/10/1/308

Since then I have had a private report that upgrading libtool would
solve the issue, but I have to admit I'm a bit skeptical, as I don't
quite get how libtool would be involved in the kernel building process
at all.

-- 
Jean Delvare
