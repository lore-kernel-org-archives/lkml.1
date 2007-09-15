Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbXIOI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbXIOI5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXIOI5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:57:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49904 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXIOI5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:57:10 -0400
Date: Sat, 15 Sep 2007 10:57:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Emil Medve <Emilian.Medve@Freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, i2c@lm-sensors.org,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH] Move the definition of pr_err() into kernel.h
In-Reply-To: <20070912125915.5b5d8aa5@oldman>
Message-ID: <Pine.LNX.4.64.0709151053400.13411@fbirervta.pbzchgretzou.qr>
References: <11895225651521-git-send-email-Emilian.Medve@Freescale.com>
 <20070912125915.5b5d8aa5@oldman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 12 2007 12:59, Stephen Hemminger wrote:
>> Other pr_*() macros are already defined in kernel.h, but pr_err() was defined
>> multiple times in several other places
>> 
>> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
>
>pr_error seems better than pr_err
>
>Please add the full set:
>	pr_alert
>	pr_critical
>        pr_error
>        pr_warn
>        pr_notice

I repeat to be totally against this.

(1) You are trying to add pr_*(fmt, arg) as a lazy shorthand for 
printk(KERN_* fmt, arg...) and

(2) do not seem to notice that pr_debug() changes its behavior 
depending on -DDEBUG, which pr_alert() etc. do not, so there
is IMHO no point (that includes the already existing pr_info()).
Why not just obsolete printk() altogether then?

