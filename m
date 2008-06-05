Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbYFESnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbYFESnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759013AbYFESnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:43:22 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:34558 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbYFESnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:43:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] include/linux/ssb/ssb_driver_gige.h typo fix
Date: Thu, 5 Jun 2008 20:42:43 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
References: <20080605182945.GO1469@cs181133002.pp.htv.fi>
In-Reply-To: <20080605182945.GO1469@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052042.43670.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 20:29:49 Adrian Bunk wrote:
> This patch fixes a typo in the name of a config variable.

Well, it's not a typo. It was renamed. Good catch anyway. :)

> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Reviewed-by: Michael Buesch <mb@bu3sch.de>

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
> 
> 



-- 
Greetings Michael.
