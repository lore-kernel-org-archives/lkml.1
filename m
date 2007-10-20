Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXJTIMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXJTIMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 04:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbXJTIMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 04:12:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41992 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbXJTIMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 04:12:00 -0400
Date: Sat, 20 Oct 2007 10:13:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: kbuild: kconfig source with " " or not
Message-ID: <20071020081334.GA5341@uranus.ravnborg.org>
References: <86802c440710200030y4bdff609m35966a6300f697b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440710200030y4bdff609m35966a6300f697b2@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai.

On Sat, Oct 20, 2007 at 12:30:50AM -0700, Yinghai Lu wrote:
> Sam,
> 
> in Kconfig, most of source to include other kconfig has "..."
> 
> for example:
> 
> in arch/x86_64/Kconfig:
> source "net/Kconfig"
> 
> but some other don't
> 
> < ./drivers/w1/Kconfig:source drivers/w1/masters/Kconfig
> < ./drivers/w1/Kconfig:source drivers/w1/slaves/Kconfig
> < ./drivers/i2c/Kconfig:source drivers/i2c/algos/Kconfig
> < ./drivers/i2c/Kconfig:source drivers/i2c/busses/Kconfig
> < ./drivers/i2c/Kconfig:source drivers/i2c/chips/Kconfig
> < ./arch/frv/Kconfig:source kernel/power/Kconfig
> < ./arch/v850/Kconfig:source init/Kconfig
> < ./arch/v850/Kconfig:source drivers/mtd/Kconfig
> < ./arch/v850/Kconfig:source drivers/parport/Kconfig
> < ./arch/v850/Kconfig:#source drivers/pnp/Kconfig
> < ./arch/v850/Kconfig:source drivers/block/Kconfig
> < ./arch/v850/Kconfig:#source drivers/misc/Config.in
> < ./arch/ia64/Kconfig:source kernel/Kconfig.hz
> < ./arch/i386/Kconfig:source kernel/Kconfig.hz
> < ./arch/i386/Kconfig:source kernel/power/Kconfig
> < ./arch/ppc/Kconfig:source arch/ppc/platforms/4xx/Kconfig
> < ./arch/ppc/Kconfig:source arch/ppc/platforms/85xx/Kconfig
> < ./arch/ppc/Kconfig:source kernel/Kconfig.hz
> < ./arch/ppc/Kconfig:source kernel/Kconfig.preempt
> < ./arch/ppc/Kconfig:source kernel/power/Kconfig
> < ./arch/x86_64/Kconfig:source kernel/Kconfig.hz
> < ./arch/x86_64/Kconfig:source kernel/power/Kconfig
> < ./arch/x86_64/Kconfig:source drivers/Kconfig
> < ./arch/x86_64/Kconfig:source fs/Kconfig
> < ./arch/s390/Kconfig:source kernel/Kconfig.hz
> < ./arch/cris/Kconfig:source mm/Kconfig
> < ./arch/cris/Kconfig:source arch/cris/arch-v10/Kconfig
> < ./arch/cris/Kconfig:source arch/cris/arch-v10/drivers/Kconfig
> < ./arch/cris/Kconfig:#source drivers/misc/Config.in
> < ./arch/powerpc/Kconfig:source kernel/time/Kconfig
> < ./arch/powerpc/Kconfig:source kernel/Kconfig.hz
> < ./arch/powerpc/Kconfig:source kernel/Kconfig.preempt
> < ./arch/powerpc/Kconfig:source kernel/power/Kconfig
> < ./arch/sh64/Kconfig:source init/Kconfig
> < ./arch/sh/Kconfig:source kernel/Kconfig.hz
> < ./arch/sh/Kconfig:source kernel/power/Kconfig
> < ./arch/sparc64/Kconfig:source kernel/Kconfig.hz
> < ./arch/arm/Kconfig:source arch/arm/mm/Kconfig
> < ./arch/blackfin/Kconfig:source kernel/Kconfig.hz
> < ./block/Kconfig:source block/Kconfig.iosched
> < ./security/Kconfig:source security/selinux/Kconfig
> 
> better to keep them consistent

Agree - but on the other hand we do not want an all-over-the-tree
patch to fix it up.
If you are up to fix it then please send the patches to the
relevant subsystem/arch maintainers.
When we are almost done we could let kconfig warn if "" is missing.

PS. Added linux-kbuild@vger.kernel.org

	Sam
