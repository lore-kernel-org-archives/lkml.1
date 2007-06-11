Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbXFJXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbXFJXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 19:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbXFJXZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 19:25:20 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:55991 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839AbXFJXZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 19:25:20 -0400
X-Greylist: delayed 1122 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2007 19:25:19 EDT
Date: Mon, 11 Jun 2007 02:05:47 +0200
From: DervishD <privado@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: radeonfb problem in 2.6.19.5
Message-ID: <20070611000456.GA1817@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :))

    If I enable CONFIG_FB + CONFIG_FB_RADEON + CONFIG_DRM +
CONFIG_DRM_RADEON, my system hangs badly as soon as I start X Window
System (namely X.Org 7.2, although it happens in older versions too).

    I'm not completely sure about the hanging: the system may not be
hung, but I don't have a console and the keyboard doesn't work, so I
cannot go back to a VT. For me, it's hung.

    I've tested different combinations, and if I remove the DRM part,
then XOrg works but it slows to a crawl. If I remove the framebuffer
support, then I can load the DRM part and X works great (only I need the
console with framebuffer, so...).

    I've tried "UseFBDev", I've tried setting the same resolution in the
framebuffer and the XOrg, etc. and nothing works. X hangs the system if
I use the framebuffer :(((

    The system is a DIY Linux box with vanilla 2.6.19.5, XOrg 7.2 (self
compiled, tested with Debian XOrg and Ubuntu XOrg too) and a PCIe ATI
Radeon X300 (chipset RV370) running on an AMD64 system.

    Is there anything I can do to be able to use both framebuffer
(100x30, which is 800x600) and XOrg without having to wait 15 seconds in
each screen redraw under X?

    Thanks a lot in advance :))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
