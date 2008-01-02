Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYABJbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYABJbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYABJbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:31:35 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:26235 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbYABJbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:31:33 -0500
Subject: Re: (Try #3) [Patch 3/8] S390: Remove 'TOPDIR' from Makefile
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-s390@vger.kernel.org
In-Reply-To: <20080102064219.GG2493@hacking>
References: <20080101071311.GA2496@hacking> <20080101072555.GD2496@hacking>
	 <20080101101720.GC28913@uranus.ravnborg.org>
	 <20080101132739.GC2499@hacking>
	 <20080101174214.GB31575@uranus.ravnborg.org>
	 <20080102064219.GG2493@hacking>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 02 Jan 2008 10:31:35 +0100
Message-Id: <1199266295.9147.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-02 at 14:42 +0800, WANG Cong wrote:
> diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
> index 56cb710..b3b650a 100644
> --- a/arch/s390/kernel/Makefile
> +++ b/arch/s390/kernel/Makefile
> @@ -31,7 +31,3 @@ S390_KEXEC_OBJS := machine_kexec.o crash.o
>  S390_KEXEC_OBJS += $(if
> $(CONFIG_64BIT),relocate_kernel64.o,relocate_kernel.o)
>  obj-$(CONFIG_KEXEC) += $(S390_KEXEC_OBJS)
> 
> -#
> -# This is just to get the dependencies...
> -#
> -binfmt_elf32.o:        $(TOPDIR)/fs/binfmt_elf.c

This one is correct. I'll add it to git390.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


