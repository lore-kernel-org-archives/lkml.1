Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbYKQQjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbYKQQjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYKQQjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:39:32 -0500
Received: from mail.suse.de ([195.135.220.2]:50006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYKQQjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:39:31 -0500
Date: Mon, 17 Nov 2008 17:39:30 +0100
From: Bernhard Walle <bwalle@suse.de>
To: John Keller <jpk@sgi.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Keller <jpk@sgi.com>
Subject: Re: [PATCH] ia64: SN specific version of dma_get_required_mask()
Message-ID: <20081117173930.35342b31@hale.suse.de>
In-Reply-To: <20081117162454.169426.74531.sendpatchset@attica.americas.sgi.com>
References: <20081117162454.169426.74531.sendpatchset@attica.americas.sgi.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Keller [2008-11-17 10:24]:
>
> Create a platform specific version of dma_get_required_mask()
> for ia64 SN Altix. All SN Altix platforms support 64 bit DMA
> addressing regardless of the size of system memory.
> Create a ia64 machvec for dma_get_required_mask, with the
> SN version unconditionally returning DMA_64BIT_MASK.

Maybe we should then switch the ia64_platform_is("sn2")
in check_crashkernel_memory() to dma_get_required_mask() ==
DMA_64BIT_MASK because that's basically what the check is about.

BTW: What about UV?


Regards,
Bernhard
-- 
Bernhard Walle, SUSE Linux Products GmbH, Architecture Development
