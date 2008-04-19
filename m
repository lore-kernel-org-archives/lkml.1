Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYDSJNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYDSJNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYDSJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:12:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35528
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbYDSJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:12:58 -0400
Date: Sat, 19 Apr 2008 02:12:56 -0700 (PDT)
Message-Id: <20080419.021256.26059313.davem@davemloft.net>
To: khali@linux-fr.org
Cc: paulus@samba.org, jochen@scram.de, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       scottwood@freescale.com, i2c@lm-sensors.org
Subject: Re: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF
 helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080419110934.672648e6@hyperion.delvare>
References: <18441.33181.511355.338428@cargo.ozlabs.ibm.com>
	<20080418.231128.97404791.davem@davemloft.net>
	<20080419110934.672648e6@hyperion.delvare>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>
Date: Sat, 19 Apr 2008 11:09:34 +0200

> Guys, you're doing things the wrong way around. Breaking things to fix
> them later is not OK, it's a pain for testers and also when bisecting
> the kernel. Everything should still work after merging the powerpc
> tree. Dave, if you need to loosen the dependency, you should do it
> yourself _after_ having changed whatever needs to be in the sparc32 and
> sparc64 trees so that loosening the dependency doesn't break anything.
> As far as I can see it's only a matter of changing one line in a
> Kconfig file, that's not exactly difficult to do it in the right order.

Fair enough.

At least don't move this stuff under arch/powerpc as paulus originally
had suggested.
