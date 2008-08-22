Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYHVBgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYHVBgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYHVBf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:35:59 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59148 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYHVBf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:35:58 -0400
Message-ID: <48AE1802.5090301@lwfinger.net>
Date: Thu, 21 Aug 2008 20:36:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Help with compiler warning
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/pcmcia/cardbus.c, the following statement

         memcpy_fromio(ptr, s->cb_cis_virt + addr, len);

generates the warning

   CC [M]  drivers/pcmcia/cardbus.o
include/asm/io_32.h: In function ‘memcpy_fromio’:
include/asm/io_32.h:151: warning: passing argument 2 of ‘__memcpy’ 
discards qualifiers from pointer target type

s->cb_cis_virt is "void __iomem" and addr is uint.

What cast does argument 2 need to silence the warning?

Thanks,

Larry
