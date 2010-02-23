Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0BWLTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 06:19:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab0BWLTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 06:19:36 -0500
Message-ID: <4B83B9C2.8040500@suse.cz>
Date: Tue, 23 Feb 2010 12:19:30 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.lernel.org, linux-kbuild@vger.kernel.org
Subject: Re: CROSS_COMPILE not taken into account on parisc64?
References: <alpine.SOC.1.00.1002231008460.18041@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1002231008460.18041@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.2.2010 09:17, Meelis Roos wrote:
> I am trying to build 2.6.33-rc* for a 64-bit parisc machine (using 
> kernel.package in Debian unstable if it matters). The build 
> fails assembling any .ko files with objcopy:
> 
> objcopy --add-gnu-debuglink=/home/mroos/linux-2.6/debian/linux-image-2.6.33-rc8-00173-g627fa17/usr/lib/debug/lib/modules/2.6.33-rc8-00173-g627fa17/kernel/drivers/cdrom/cdrom.ko /home/mroos/linux-2.6/debian/linux-image-2.6.33-rc8-00173-g627fa17/lib/modules/2.6.33-rc8-00173-g627fa17/kernel/drivers/cdrom/cdrom.ko
> objcopy:/home/mroos/linux-2.6/debian/linux-image-2.6.33-rc8-00173-g627fa17/lib/modules/2.6.33-rc8-00173-g627fa17/kernel/drivers/cdrom/cdrom.ko: File format not recognized

I guess this objcopy command is run outside of the kernel build system
(a packaging script storing debug info in /usr/lib/debug), nothing the
kernel makefiles can do about.


[...]
> However, I see no inclusion of arch-specific Makefile before the 
> assignment of OBJCOPY in main Makefile. Could this be the problem?

That's OK, make variables assigned with '=' are expanded when they are used.

Michal
