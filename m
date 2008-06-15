Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYFOWRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYFOWRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 18:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYFOWRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 18:17:23 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55350 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYFOWRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 18:17:22 -0400
Date: Mon, 16 Jun 2008 01:16:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh/boards/se/770x/io.c: suspicious code
Message-ID: <20080615221606.GA1407@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sh_pcic_io_start and sh_pcic_io_stop are used as lower and upper limits 
for ports but never set to any non-zero value.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

