Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbXINQpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbXINQpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbXINQoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:44:55 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:53641 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbXINQoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:44:54 -0400
Date: Sat, 15 Sep 2007 01:09:40 +0900 (JST)
Message-Id: <20070915.010940.25476256.anemo@mba.ocn.ne.jp>
To: david@gibson.dropbear.id.au
Cc: akpm@osdl.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: rtc-ds1742.c should use resource_size_t for base address
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070914055427.GM481@localhost.localdomain>
References: <20070914055427.GM481@localhost.localdomain>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 15:54:27 +1000, David Gibson <david@gibson.dropbear.id.au> wrote:
> Currently the rtc driver, rtc-ds1742.c uses an unsigned long to store
> the base mmio address of the NVRAM/RTC.  This breaks on systems like
> PowerPC 440, which is a 32-bit core with 36-bit physical addresses: IO
> on the system, including the RTC, is typically above the 4GB point,
> and cannot fit into an unsigned long.
> 
> This patch fixes the problem by replacing the unsigned long with a
> resource_size_t.  Tested on Ebony (PPC440) (with additional patches to
> instantiate the ds1742 platform device appropriately).
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Thanks!

Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
