Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYDSJKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYDSJKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYDSJKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:10:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37682 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYDSJJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:09:59 -0400
Date: Sat, 19 Apr 2008 11:09:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, jochen@scram.de, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       scottwood@freescale.com, i2c@lm-sensors.org
Subject: Re: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF 
 helpers
Message-ID: <20080419110934.672648e6@hyperion.delvare>
In-Reply-To: <20080418.231128.97404791.davem@davemloft.net>
References: <18441.28496.84724.411784@cargo.ozlabs.ibm.com>
	<20080418.210933.01471700.davem@davemloft.net>
	<18441.33181.511355.338428@cargo.ozlabs.ibm.com>
	<20080418.231128.97404791.davem@davemloft.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 23:11:28 -0700 (PDT), David Miller wrote:
> From: Paul Mackerras <paulus@samba.org>
> Date: Sat, 19 Apr 2008 15:22:37 +1000
> 
> > David Miller writes:
> > > From: Paul Mackerras <paulus@samba.org>
> > > Date: Sat, 19 Apr 2008 14:04:32 +1000
> > > 
> > > It's OK if this breaks the sparc64 allmodconfig build, I'll take
> > > care of this once it's merged in.
> > 
> > It breaks the sparc32 allmodconfig build, which seems to be a
> > concern.  How do you suggest we fix that?
> 
> I'll fix both sparc64 and sparc32 builds when I merge my sparc
> tree in.

Guys, you're doing things the wrong way around. Breaking things to fix
them later is not OK, it's a pain for testers and also when bisecting
the kernel. Everything should still work after merging the powerpc
tree. Dave, if you need to loosen the dependency, you should do it
yourself _after_ having changed whatever needs to be in the sparc32 and
sparc64 trees so that loosening the dependency doesn't break anything.
As far as I can see it's only a matter of changing one line in a
Kconfig file, that's not exactly difficult to do it in the right order.

Thanks,
-- 
Jean Delvare
