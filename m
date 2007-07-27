Return-Path: <linux-kernel-owner+w=401wt.eu-S937293AbXG0QXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937293AbXG0QXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763275AbXG0QXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:23:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:59398 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762985AbXG0QXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:23:43 -0400
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Jan Dittmer <jdi@l4x.org>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, trenn <trenn@suse.de>
In-Reply-To: <46A98FF9.8060801@l4x.org>
References: <200707251238.50218.lenb@kernel.org>  <46A98FF9.8060801@l4x.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 18:25:12 +0200
Message-Id: <1185553512.3849.46.camel@noname>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 08:26 +0200, Jan Dittmer wrote:
> Len Brown wrote:
> > Hi Linus,
> > 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> This seems to break ia64 defconfig:
> 
>    Building modules, stage 2.
>    MODPOST 157 modules
> FATAL: drivers/acpi/button: sizeof(struct acpi_device_id)=20 is not a modulo of the size of section __mod_acpi_device_table=144.
> Fix definition of struct acpi_device_id in mod_devicetable.h
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make: *** [_all] Error 2
> 
> gcc 3.3.6, binutils 2.15.94
> 
> http://l4x.org/k/?d=32569

This is strange, I just compiled on a IA64 with button as module
(defconfig), but with gcc version 4.1.2, all is fine.
Anyone an idea how to run into that?

I won't be able to detailed debug this before Monday, but be sure I will
do so then.

Thanks,

    Thomas

