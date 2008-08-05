Return-Path: <linux-kernel-owner+w=401wt.eu-S1761583AbYHEPjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbYHEPjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbYHEPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:39:22 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39774 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725AbYHEPjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:39:20 -0400
Date: Tue, 5 Aug 2008 18:37:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: linux-next: wireless-current tree build failure
Message-ID: <20080805153757.GB22895@cs181140183.pp.htv.fi>
References: <20080805162152.2b55ae5c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080805162152.2b55ae5c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 04:21:52PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/net/wireless/ath9k/hw.c: In function 'ath9k_hw_9280_spur_mitigate':
> drivers/net/wireless/ath9k/hw.c:4660: internal compiler error: in expand_expr_real_1, at expr.c:9199
> 
> Clearly not our fault! :-) I have informed our toolchain person.  This
> was using the Debian gcc-4.3.  It also fails using the Debian 4.2
> compiler but not the 4.1 one.
>...

Alexandros Couloumbis already opened a bug for this issue on mips, which 
also seems to be affected:
  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37014

It is a gcc bug, but we'll have to work around it in the ath9k driver.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

