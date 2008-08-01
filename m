Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYHAU26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYHAU26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYHAU2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:28:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYHAU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:28:50 -0400
Date: Fri, 1 Aug 2008 11:26:12 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 1 (sysfs.h)
Message-ID: <20080801182612.GB4788@kroah.com>
References: <20080801165808.68f833ec.sfr@canb.auug.org.au> <20080801111452.1b4c55d3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801111452.1b4c55d3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 11:14:52AM -0700, Randy Dunlap wrote:
> When CONFIG_SYSFS=n:
> 
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from linux-next-20080801/include/linux/kobject.h:21,
>                  from linux-next-20080801/include/linux/module.h:16,
>                  from linux-next-20080801/include/linux/crypto.h:21,
>                  from linux-next-20080801/arch/x86/kernel/asm-offsets_64.c:7,
>                  from linux-next-20080801/arch/x86/kernel/asm-offsets.c:4:
> linux-next-20080801/include/linux/sysfs.h:247: error: return type is an incomplete type
> linux-next-20080801/include/linux/sysfs.h: In function 'sysfs_get':
> linux-next-20080801/include/linux/sysfs.h:248: warning: 'return' with a value, in function returning void
> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1

Ah, missed a "*".  It's Neil's fault :)

I'll go fix this up, it's for when CONFIG_SYSFS is set to N, right?

thanks,

greg k-h
