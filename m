Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbYLWO0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbYLWO0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYLWO0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:26:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYLWO0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:26:36 -0500
Date: Tue, 23 Dec 2008 15:25:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org, ralf@linux-mips.org, kernel@wantstofly.org,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH -tip] Switch arm defconfig files from
	CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Message-ID: <20081223142542.GC29151@elte.hu>
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* paulmck@linux.vnet.ibm.com <paulmck@linux.vnet.ibm.com> wrote:

> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Only for testing in -tip and -next, not yet for inclusion into mainline.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  arch/arm/configs/afeb9260_defconfig     |    2 +-
>  arch/arm/configs/am200epdkit_defconfig  |    2 +-
>  arch/arm/configs/cm_x300_defconfig      |    2 +-
>  arch/arm/configs/corgi_defconfig        |    2 +-
>  arch/arm/configs/csb637_defconfig       |    2 +-
>  arch/arm/configs/eseries_pxa_defconfig  |    2 +-
>  arch/arm/configs/ezx_defconfig          |    2 +-
>  arch/arm/configs/imx27ads_defconfig     |    2 +-
>  arch/arm/configs/jornada720_defconfig   |    2 +-
>  arch/arm/configs/kirkwood_defconfig     |    2 +-
>  arch/arm/configs/loki_defconfig         |    2 +-
>  arch/arm/configs/magician_defconfig     |    2 +-
>  arch/arm/configs/mv78xx0_defconfig      |    2 +-
>  arch/arm/configs/mx31ads_defconfig      |    2 +-
>  arch/arm/configs/mx31litekit_defconfig  |    2 +-
>  arch/arm/configs/omap3_beagle_defconfig |    2 +-
>  arch/arm/configs/omap_h2_1610_defconfig |    2 +-
>  arch/arm/configs/omap_ldp_defconfig     |    2 +-
>  arch/arm/configs/orion5x_defconfig      |    2 +-
>  arch/arm/configs/overo_defconfig        |    2 +-
>  arch/arm/configs/palmz72_defconfig      |    2 +-
>  arch/arm/configs/pcm037_defconfig       |    2 +-
>  arch/arm/configs/pcm038_defconfig       |    2 +-
>  arch/arm/configs/s3c2410_defconfig      |    2 +-
>  arch/arm/configs/spitz_defconfig        |    2 +-
>  arch/arm/configs/tct_hammer_defconfig   |    2 +-
>  arch/arm/configs/viper_defconfig        |    2 +-
>  arch/arm/configs/xm_x2xx_defconfig      |    2 +-
>  28 files changed, 28 insertions(+), 28 deletions(-)

ouch!

There's a much more shrewd method to achieve the same, via 2 lines total 
patch:

Change the name of CONFIG_CLASSIC_RCU to something else such as 
CONFIG_FLAT_RCU. That does all the magic and more: all configs will 
default to tree-rcu - not just defconfigs! Agreed?

[ I think the gene of laziness is probably more developed in my genome
  than in yours. It is a very useful trait ;-) ]

	Ingo
