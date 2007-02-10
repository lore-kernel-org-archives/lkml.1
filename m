Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbXBJLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbXBJLgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXBJLgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:36:21 -0500
Received: from vscan01.westnet.com.au ([203.10.1.131]:45813 "EHLO
	vscan01.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXBJLgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:36:20 -0500
X-Greylist: delayed 1188 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Feb 2007 06:36:20 EST
Message-ID: <45CDA98A.2030608@snapgear.com>
Date: Sat, 10 Feb 2007 21:16:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH]: linux-2.6.20-uc0 (MMU-less updates)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

An update of the uClinux (MMU-less) code against 2.6.20.
Mostly cleanups, and a couple of bug fixes.

I have included a new style serial driver for the ColdFire too.
Eventually I would like to replace the old style mcfserial.c
driver with this. This is a good place to start testing and
reviewing it more throughly.

http://www.uclinux.org/pub/uClinux/uClinux-2.6.x/linux-2.6.20-uc0.patch.gz


Change log:

. use ARRAY_SIZE macro                          Ahmed S. Darwish
. fix interrupt handler types for m68knommu     Greg Ungerer
. remove regs arg from m68knommu timers         Greg Ungerer
. add "unused" sections to m68knommu linker     Greg Ungerer
. fix INIT_WORK usage in coldfire fec driver    Greg Ungerer
. enable second phy on 5275                     Mike Cruse
. fix INIT_WORK usage in old mcfserial.c        Greg Ungerer
. fix pin assignment for 5282 in mcfserial.c    David Wu
. remap mem mapping for flat fmt exes           Greg Ungerer
. clean includes not needed m68knommu bitops.h  Greg Ungerer
. use minimum whole pages for hash allocations  David McCullough


Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a division of Secure Computing  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
