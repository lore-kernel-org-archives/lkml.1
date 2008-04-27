Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbYD0SEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbYD0SEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbYD0SDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:03:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:52383 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbYD0SDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:03:51 -0400
Date: Sun, 27 Apr 2008 20:03:46 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: linuxppc-dev@ozlabs.org
cc: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25: pmac_newworld undefined
Message-ID: <alpine.DEB.1.10.0804271951190.11017@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+qiTEeHWxRmAntvIKkstypjKkgGI7Wogz+x5Z
 YFPh4wC3pTNGG2bkmgCHidIEmLlymf9jnA2i/dZRrU1at6jqSQ
 ZKFyfpTUWHfaRA5/2yH/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the build failure reported[0] by Kamalesh back in 01/2008 is still 
present in today's 2.6.25-git with CONFIG_NVRAM=m (instead of =y):

   Building modules, stage 2.
   MODPOST 72 modules
ERROR: "pmac_newworld" [arch/powerpc/platforms/powermac/nvram.ko] undefined!
ERROR: "__alloc_bootmem" [arch/powerpc/platforms/powermac/nvram.ko] undefined!
make[1]: *** [__modpost] Error 1

Full .config and make.log: http://nerdbynature.de/bits/2.6.25/nvram/

I could not find an #ifdef or sth. around pmac_newworld....

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/1/17/55
-- 
BOFH excuse #187:

Reformatting Page. Wait...
