Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbYDSLqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbYDSLqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 07:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYDSLqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 07:46:05 -0400
Received: from ozlabs.org ([203.10.76.45]:33079 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbYDSLqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 07:46:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18441.56170.464016.686497@cargo.ozlabs.ibm.com>
Date: Sat, 19 Apr 2008 21:45:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Miller <davem@davemloft.net>, jochen@scram.de, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       scottwood@freescale.com, i2c@lm-sensors.org
Subject: Re: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF 
 helpers
In-Reply-To: <20080419110934.672648e6@hyperion.delvare>
References: <18441.28496.84724.411784@cargo.ozlabs.ibm.com>
	<20080418.210933.01471700.davem@davemloft.net>
	<18441.33181.511355.338428@cargo.ozlabs.ibm.com>
	<20080418.231128.97404791.davem@davemloft.net>
	<20080419110934.672648e6@hyperion.delvare>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare writes:

> Guys, you're doing things the wrong way around. Breaking things to fix
> them later is not OK, it's a pain for testers and also when bisecting
> the kernel. Everything should still work after merging the powerpc
> tree. Dave, if you need to loosen the dependency, you should do it
> yourself _after_ having changed whatever needs to be in the sparc32 and
> sparc64 trees so that loosening the dependency doesn't break anything.
> As far as I can see it's only a matter of changing one line in a
> Kconfig file, that's not exactly difficult to do it in the right order.

You're right.  I'll put in a dependency on PPC_OF for now and Dave can
take it out once sparc32/64 have irq_of_parse_and_map etc.

Paul.
