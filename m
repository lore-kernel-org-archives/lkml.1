Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbXEQG5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbXEQG5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXEQG5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:57:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbXEQG5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:57:41 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Linux 2.6.22-rc1
Date: Thu, 17 May 2007 02:55:37 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <Pine.LNX.4.61.0705131105400.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705131105400.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705170255.37347.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 May 2007 05:20, Jan Engelhardt wrote:
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

CONFIG_PM=n
CONFIG_ACPI=y

not possible.
"select" in Kconfig is broken.

http://lkml.org/lkml/2007/4/28/28

-Len
