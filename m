Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbXEBFXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbXEBFXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXEBFXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:23:42 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58567 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbXEBFXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:23:41 -0400
Message-ID: <46382055.8030203@snapgear.com>
Date: Wed, 02 May 2007 15:23:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

An update of the uClinux (MMU-less) code against 2.6.21.
A lot of cleanups, and a few bug fixes.

Ahead is more changes to finalize platform device support
for the new style ColdFire serial driver, and switching to
the generic irq code.

http://www.uclinux.org/pub/uClinux/uClinux-2.6.x/linux-2.6.21-uc0.patch.gz


Change log:

. Arctururs UC5272 and UC5282 board support        David Wu
. use THREAD_SIZE for stack manipulation           Philippe De Muyter
. remove dead code from setup.c                    Greg Ungerer
. remove dead cache code from mm                   Greg Ungerer
. remove useless is_in_rom()                       Greg Ungerer
. consolidate fixed bootparam code                 Greg Ungerer
. no need to preserve THREAD_SR in resume          Philippe De Muyter
. implement irq_regs in interrupt service          Greg Ungerer
. remove machine specific irq code                 Greg Ungerer
. fix timer step count for ColdFire                Philippe De Muyter
. add chip select mappings for cobra5329           Thomas Brinker
. remove old machine specific clock defines        Greg Ungerer
. improve readability of fec driver code           Philippe De Muyter
. do not read ICR before writing in fec driver     Philippe De Muyter
. fix INIT_WORK usage in fec driver                Greg Ungerer
. remove legacy PM code in 68328 serial driver     Greg Ungerer
. fix errno reporting in binfmt_flat loader        Philippe De Muyter
. create hw_irq.h for m68knommu                    Greg Ungerer
. fix CLOCK_TICK_RATE for m68knommu                Philippe De Muyter
. add expand_stack() funtcion to nommu             Greg Ungerer
. move to platform device setup for 520x           Greg Ungerer
. move to platform device setup for 5249           Greg Ungerer
. new style serial driver for ColdFire UART        Greg Ungerer
. add QSPI defines for 528x ColdFire parts         David Wu
. improve SoC device defines for 523x ColdFire     Thomas Brinker


Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a division of Secure Computing  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com

