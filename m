Return-Path: <linux-kernel-owner+w=401wt.eu-S1761916AbXENBz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761916AbXENBz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 21:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759283AbXENBzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 21:55:49 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:53130 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597AbXENBzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 21:55:48 -0400
Date: Mon, 14 May 2007 10:55:41 +0900
From: Mattia Dongili <malattia@linux.it>
To: linux-acpi@vger.kernel.org, jengelh@linux01.gwdg.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: Re: Linux 2.6.22-rc1
Message-ID: <20070514015541.GB4800@inferi.kami.home>
References: <Pine.LNX.4.61.0705131123280.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705131123280.9570@yvahk01.tjqt.qr>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc7-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 11:27:31AM +0200, Jan Engelhardt wrote:
> On May 12 2007 20:20, Linus Torvalds wrote:
> >
> >Ok, the merge window has closed, and 2.6.22-rc1 is out there.
> 
> I have hit a randconfig compile failure. .config attached.
> 
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `acpi_bus_generate_event':
> (.text+0x233f7): undefined reference to `event_is_open'
> drivers/built-in.o: In function `acpi_bus_get_power':
> (.text+0x236ad): undefined reference to `acpi_power_get_inferred_state'
> drivers/built-in.o: In function `acpi_bus_set_power':
> (.text+0x237c3): undefined reference to `acpi_power_transition'
> drivers/built-in.o: In function `acpi_bus_set_power':
> (.text+0x23835): undefined reference to `acpi_power_transition'
> drivers/built-in.o: In function `sony_pic_fanspeed_store':
> sony-laptop.c:(.text+0x91930): undefined reference to `ec_write'
> drivers/built-in.o: In function `sony_pic_fanspeed_show':
> sony-laptop.c:(.text+0x9195d): undefined reference to `ec_read'
> make: *** [.tmp_vmlinux1] Error 1

I actually can't reproduce it with your .config.
>From a clean tree, running make fires up the oldconfig which fixes the
many missing/garbled dependencies. In any case SONY_LAPTOP depends on
ACPI which always build EC statically if selected.

clues?

-- 
mattia
:wq!
