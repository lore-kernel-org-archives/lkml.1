Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYHZJhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYHZJhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYHZJhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:37:48 -0400
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:35021 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYHZJhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:37:48 -0400
Message-ID: <48B3CEEA.90400@numericable.fr>
Date: Tue, 26 Aug 2008 11:37:46 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008082610)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [2.6.27-rc4-git4] compilation warnings
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Fresh 2.6.27-rc4-git4 causes these compilation warnings on my amd64 box 
with gcc-4.3.1 :

drivers/pci/search.c: In function ‘pci_get_dev_by_id’:
drivers/pci/search.c:284: attention : passing argument 1 of 
‘pci_dev_put’ discards qualifiers from pointer target type

following this commit : ebca4f1bce1eb7b91a63c515db66316db9391221 
PCI: fix reference leak in pci_get_dev_by_id()
---
drivers/video/aty/aty128fb.c: In function ‘aty128_decode_var’:
drivers/video/aty/aty128fb.c:1520: attention : ‘pll.post_divider’ may be 
used uninitialized in this function

Regards.

