Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbZBSBu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbZBSBu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZBSBuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:50:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41250
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbZBSBuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:50:14 -0500
Date: Wed, 18 Feb 2009 17:49:58 -0800 (PST)
Message-Id: <20090218.174958.248510917.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, bhutchings@solarflare.com,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/sfc: fix sparse warnings: Should it be
 static?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090216095351.391.49056.stgit@vmbox.hanneseder.net>
References: <154e089b0902160138n255616a0xb963dfd990d912b@mail.gmail.com>
	<20090216095351.391.49056.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 16 Feb 2009 10:54:38 +0100

> Impact: Include the header file.  If CONFIG_SFC_MTD is not defined
> then the functions 'efx_mtd_remove' and 'efx_mtd_rename' are defined
> 'static inline' with an empty function body in the header file, but
> the the whole file mtd.c is not built in this case.
> 
> Fix this sparse warnings:
>   drivers/net/sfc/mtd.c:204:6: warning: symbol 'efx_mtd_remove' was not declared. Should it be static?
>   drivers/net/sfc/mtd.c:221:6: warning: symbol 'efx_mtd_rename' was not declared. Should it be static?
>   drivers/net/sfc/mtd.c:230:5: warning: symbol 'efx_mtd_probe' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied to net-next-2.6, thanks.
