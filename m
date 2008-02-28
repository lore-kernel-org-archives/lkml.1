Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYB1Kbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYB1Kbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYB1Kb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:31:26 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:54591 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYB1KbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:31:24 -0500
Date: Thu, 28 Feb 2008 11:30:34 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Jeff Garzik <jeff@garzik.org>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6.25 patch] FIXED_PHY must depend on PHYLIB=y
Message-ID: <20080228103034.GA8174@aepfle.de>
References: <200802271158.00453.olaf@aepfle.de> <20080227150754.GA29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080227150754.GA29269@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, Adrian Bunk wrote:

> This patch fixes the following build error introduced by commit 
> a79d8e93d300adb84cccc38ac396cfb118c238ad and reported by Olaf Hering:
> 
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> arch/powerpc/sysdev/built-in.o: In function `of_add_fixed_phys':
> fsl_soc.c:(.init.text+0xd34): undefined reference to `fixed_phy_add'
> make: *** [.tmp_vmlinux1] Error 1

Yes, this patch helps.
Thanks.

