Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYJNSkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYJNSkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYJNSkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:40:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41543 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYJNSkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:40:45 -0400
Date: Tue, 14 Oct 2008 21:39:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>
Subject: sh/boards/mach-migor/setup.c build error
Message-ID: <20081014183936.GB4710@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 81034663159f39d005316b5c139038459cd16721
(V4L/DVB (8687): soc-camera: Move .power and .reset from
 soc_camera host to sensor driver) causes the following build error:

<--  snip  -->

...
  CC      arch/sh/boards/mach-migor/setup.o
arch/sh/boards/mach-migor/setup.c:408: error: unknown field 'enable_camera' specified in initializer
arch/sh/boards/mach-migor/setup.c:408: warning: excess elements in struct initializer
arch/sh/boards/mach-migor/setup.c:408: warning: (near initialization for 'sh_mobile_ceu_info')
arch/sh/boards/mach-migor/setup.c:409: error: unknown field 'disable_camera' specified in initializer
arch/sh/boards/mach-migor/setup.c:409: warning: excess elements in struct initializer
arch/sh/boards/mach-migor/setup.c:409: warning: (near initialization for 'sh_mobile_ceu_info')
make[2]: *** [arch/sh/boards/mach-migor/setup.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

