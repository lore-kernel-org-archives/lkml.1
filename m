Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYDSEJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYDSEJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 00:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYDSEJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 00:09:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49534
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbYDSEJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 00:09:32 -0400
Date: Fri, 18 Apr 2008 21:09:33 -0700 (PDT)
Message-Id: <20080418.210933.01471700.davem@davemloft.net>
To: paulus@samba.org
Cc: jochen@scram.de, sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, scottwood@freescale.com,
       i2c@lm-sensors.org, khali@linux-fr.org
Subject: Re: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF
 helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <18441.28496.84724.411784@cargo.ozlabs.ibm.com>
References: <4808AEC7.8040000@scram.de>
	<18441.28496.84724.411784@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Sat, 19 Apr 2008 14:04:32 +1000

> Jochen Friedrich writes:
> 
> > Fix build breakage introduced in commit
> > "[POWERPC] i2c: OF helpers for the i2c API".
> > If i2c-core is compiled as module, the helper needs to be
> > compiled as module, as well. Rename i2c.c to of_i2c.c to
> > avoid name space conflict.
> 
> Actually, since only powerpc has irq_of_parse_and_map, I'm now
> inclined to think that drivers/of/i2c.c should live under arch/powerpc
> for now, or at the least its option should depend on PPC_OF.

I specifically asked for this to not be PPC only so that I
can make use of this infrastructure on sparc64 for I2C devices.

It's OK if this breaks the sparc64 allmodconfig build, I'll take
care of this once it's merged in.

Please merge the PPC tree to Linus soon, so that I can merge
in my sparc64 NUMA bits which depend upon the LMB changesets
in the PPC tree.

Thanks.
