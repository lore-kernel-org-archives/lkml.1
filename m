Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbYFESfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbYFESfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYFESfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:35:00 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:59812 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYFESe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:34:59 -0400
Date: Thu, 5 Jun 2008 14:34:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Michael Buesch <mb@bu3sch.de>, "John W. Linville" <linville@tuxdriver.com>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [2.6 patch] include/linux/ssb/ssb_driver_gige.h typo fix
In-Reply-To: <20080605182945.GO1469@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0806051432220.6496@localhost.localdomain>
References: <20080605182945.GO1469@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, Adrian Bunk wrote:

> This patch fixes a typo in the name of a config variable.
>
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
> 2aab8eeb46b30baf987c344e1b144caec365373a diff --git a/include/linux/ssb/ssb_driver_gige.h b/include/linux/ssb/ssb_driver_gige.h
> index 01fbdf5..942e387 100644
> --- a/include/linux/ssb/ssb_driver_gige.h
> +++ b/include/linux/ssb/ssb_driver_gige.h
> @@ -100,7 +100,7 @@ extern char * nvram_get(const char *name);
>  /* Get the device MAC address */
>  static inline void ssb_gige_get_macaddr(struct pci_dev *pdev, u8 *macaddr)
>  {
> -#ifdef CONFIG_BCM947XX
> +#ifdef CONFIG_BCM47XX
>  	char *res = nvram_get("et0macaddr");
>  	if (res)
>  		memcpy(macaddr, res, 6);
>

just FYI, there are more (admittedly aesthetic) references to
BCM947XX in the MIPS directory:

$ grep -r "BCM947XX" *
include/linux/ssb/ssb_driver_gige.h:#ifdef CONFIG_BCM947XX
include/asm-mips/mach-bcm47xx/war.h:#ifndef __ASM_MIPS_MACH_BCM947XX_WAR_H
include/asm-mips/mach-bcm47xx/war.h:#define __ASM_MIPS_MACH_BCM947XX_WAR_H
include/asm-mips/mach-bcm47xx/war.h:#endif /* __ASM_MIPS_MACH_BCM947XX_WAR_H */
$

  whether you want to do anything about those is up to you.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
