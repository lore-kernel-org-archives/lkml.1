Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZKELvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZKELvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZKELvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:51:44 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:35625 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbZKELvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:51:44 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEBK8kpR92Ay/2dsb2JhbADeOAqEMwSBZg
Date: Thu, 5 Nov 2009 12:51:47 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Rapoport <mike@compulab.co.il>,
       Andrey Panin <pazke@centrinvest.ru>
Subject: Re: SBC-FITPC2 watchdog driver fix
Message-ID: <20091105115147.GY3999@infomag.iguana.be>
References: <4A6492EB.1080709@compulab.co.il> <4AF2B7D8.1010903@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF2B7D8.1010903@compulab.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

added in linux-2.6-watchdog-next for further testing.
Will sent this to Linus in a couple of days.

Kind regards,
Wim.

> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> 
> This patch fixes device registration process.
> 
> diff -Nru linux-2.6.32-rc6.orig/drivers/watchdog/sbc_fitpc2_wdt.c
> linux-2.6.32-rc6/drivers/watchdog/sbc_fitpc2_wdt.c
> --- linux-2.6.32-rc6.orig/drivers/watchdog/sbc_fitpc2_wdt.c    
> 2009-11-03 21:37:49.000000000 +0200
> +++ linux-2.6.32-rc6/drivers/watchdog/sbc_fitpc2_wdt.c  2009-11-05
> 13:23:11.000000000 +0200
> @@ -227,7 +227,7 @@
>         }
> 
>         err = misc_register(&fitpc2_wdt_miscdev);
> -       if (!err) {
> +       if (err) {
>                 pr_err("cannot register miscdev on minor=%d (err=%d)\n",
>                                                         WATCHDOG_MINOR,
> err);
>                 goto err_margin;
