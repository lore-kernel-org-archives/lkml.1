Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbXFBS5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbXFBS5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 14:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbXFBS5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 14:57:45 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51877 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756794AbXFBS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 14:57:44 -0400
Date: Sat, 2 Jun 2007 20:57:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dan Williams <dan.j.williams@intel.com>, mingo@redhat.com, neilb@suse.de,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>
Cc: linux-raid@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: multiple xor_block() functions
Message-ID: <20070602185746.GI5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/raid/xor.h:extern void xor_block(unsigned int count, unsigned int bytes, void **ptr);
drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes, void **ptr)
drivers/md/xor.c:EXPORT_SYMBOL(xor_block);

and

net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 * b, u8 * a, size_t len)


At least one of them has to be renamed.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

