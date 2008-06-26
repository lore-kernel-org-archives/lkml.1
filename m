Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYFZJNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYFZJNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYFZJNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:13:09 -0400
Received: from aun.it.uu.se ([130.238.12.36]:42423 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbYFZJNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:13:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18531.23894.572847.322265@harpo.it.uu.se>
Date: Thu, 26 Jun 2008 11:11:50 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Bernhard Walle <bwalle@suse.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Vivek Goyal <vgoyal@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
In-Reply-To: <20080626104524.2d7ed1ab@halley.suse.de>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de>
	<1214423826-12628-2-git-send-email-bwalle@suse.de>
	<20080625224301.GE32344@redhat.com>
	<18531.20387.111875.576837@harpo.it.uu.se>
	<20080626104524.2d7ed1ab@halley.suse.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle writes:
 > > It should be configurable. Whether it's done via CONFIG_KEXEC or its own
 > > option I don't care.
 > 
 > Ok, changed:
 > 
 > diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
 > index 1008737..73fcc59 100644
 > --- a/drivers/firmware/Kconfig
 > +++ b/drivers/firmware/Kconfig
 > @@ -28,7 +28,7 @@ config EDD_OFF
 >  
 >  config FIRMWARE_MEMMAP
 >      def_bool y
 > -    depends on X86_64 || X86_32
 > +    depends on (X86_64 || X86_32) && KEXEC
 >  
 >  config EFI_VARS
 >         tristate "EFI Variable Support via sysfs"

Yep, thanks.
