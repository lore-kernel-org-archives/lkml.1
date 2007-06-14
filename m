Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbXFNIm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbXFNIm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbXFNImU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:42:20 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:44047 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751807AbXFNImT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:42:19 -0400
X-YMail-OSG: lfuoasIVM1na63H6YIX3IZG7T3nOuaFK3AiKW2eGglaT7bRvh_6CdL0QASD4Z4QfU9wuCKPvtjep3YQj7B_jFnEjJcp33yjw4mpuKJagEHRShVJBs58-
Subject: [BUG] libata IT821X driver still fails! Hard-freezes system.
From: Rodney Gordon II <meff@spherevision.org>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Content-Type: text/plain
Date: Thu, 14 Jun 2007 03:42:16 -0500
Message-Id: <1181810536.5335.13.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the screen image I took with my digital camera when bootup
freezes:
http://spherevision.org/sync/visual/itefreeze.jpg

After this freeze, not even SysRq commands work.
On a side-note, the non-libata drivers boot up, but throw tons of DMA
errors after one DVD burn.

The kernel I tested this on (newest I would try) is 2.6.22-rc4 with and
without cfs16. I am willing to test out patches if I can get this darn
controller working.

My config: http://spherevision.org/sync/tmp/dot.config

At the time of this freeze, the kernel was not tainted. I am running a
Pentium-D 830 3.0GHz Dualcore on a ASUS P5LD2 with latest bios rev.
1804.

My lspci -vvv info: http://spherevision.org/sync/tmp/lspci.out

I also find it pecular that it says there is a 40wire cable; I have
tried 3 different 80wire cables and it doesn't make a difference. So,
yes indeed I am using proper cables, and have tried others.

Just to make sure, this a brand new 20A1P burner, the old one did the
same thing though.

If I build pata_821x(or whatnot) as a module, system freezes after about
5 seconds after insmod, without dumping any information at all. 

It may say it's a RAID controller, but on this motherboard it seems to
be pure passthru because there is no RAID option for this controller in
the BIOS. I have also tried a few flags recommended by Alan before,
which do not help.

Help would be very much appreciated! Further info, if needed, just ask.

-r








