Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYFHTGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYFHTGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 15:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYFHTGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 15:06:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42286 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbYFHTGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 15:06:02 -0400
Date: Sun, 8 Jun 2008 22:05:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: m68k: could the Apollo support possibly work?
Message-ID: <20080608190513.GE4048@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing seems to set apollo_model (apollo_parse_bootinfo() has no caller).

Therefore trying to boot an Apollo machine seems to do:
  arch/m68k/kernel/setup.c:setup_arch()
    arch/m68k/apollo/config.c:config_apollo()
      arch/m68k/apollo/config.c:dn_setup_model() 
        panic()

Do I miss anything?

Does anyone still have this hardware and tried booting it in recent years?

This problem already exists in kernel 2.4.0, and my gut feeling is 
it's quite dead code I could remove.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

