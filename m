Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZBDJIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZBDJIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZBDJHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:07:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:53100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZBDJHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:07:52 -0500
Date: Wed, 4 Feb 2009 10:07:52 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@bogon.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
cc: sparclinux@vger.kernel.org
Subject: Kernel unaligned access at TPC
Message-ID: <alpine.DEB.2.00.0902041001550.4084@bogon.housecafe.de>
User-Agent: Alpine 2.00 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18ay7cKvgDIJfLodSwfof6QJ//KvFCUGZO5IzN
 OsGlG9QeupNObnrjzIwATQdsUul7x7W15QaR7i2JDwczmeLX7L
 LkADXwjYhcV9tKV5RXsqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

while trying to track -git kernels on this Ultra5, I've seen the following 
messages during bootup since 2.6.29-rc3:

[   94.099721] Kernel unaligned access at TPC[54c818] nsm_get_handle+0x158/0x400
[   94.336558] Kernel unaligned access at TPC[54c81c] nsm_get_handle+0x15c/0x400
[   94.678623] Kernel unaligned access at TPC[54c818] nsm_get_handle+0x158/0x400
[   94.915452] Kernel unaligned access at TPC[54c81c] nsm_get_handle+0x15c/0x400
[   95.252917] Kernel unaligned access at TPC[54c818] nsm_get_handle+0x158/0x400

Searching the net only brought up a post[0] from kernel-testers, but this 
box here is running fine - no filesystem errors or anything. Are these 
messages something to worry about or can they be ignored?

Full dmesg & .config: http://nerdbynature.de/bits/2.6.29-rc3/

Thanks,
Christian.

[0] http://www.mail-archive.com/kernel-testers@vger.kernel.org/msg02959.html
-- 
BOFH excuse #129:

The ring needs another token
