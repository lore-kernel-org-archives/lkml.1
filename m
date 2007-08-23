Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbXHWGn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbXHWGn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 02:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXHWGnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 02:43:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38458 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXHWGnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 02:43:47 -0400
Date: Thu, 23 Aug 2007 12:26:38 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Mike Rapoport <mike@compulab.co.il>
cc: LKML <linux-kernel@vger.kernel.org>, Raphael Assenat <raph@8d.com>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] RTC v3020 fixes
In-Reply-To: <46CD290C.3020203@compulab.co.il>
Message-ID: <alpine.LFD.0.999.0708231222540.2049@enigma.security.iitk.ac.in>
References: <46CD290C.3020203@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, 23 Aug 2007, Mike Rapoport wrote:

No changelog for patch ?!

> -	for ( i = 0; i < 4; i++ )
> +	for ( i = 0; i < 4; i++ ) {
>  		writel((address << (16-i)), EMV3020_VA_RTC);
> +		udelay(1);
> +	}
> +
> 

^ Spurious extra newline here.

> -	BCD_TO_BIN(dt->tm_mon);
> +	BCD_TO_BIN(dt->tm_mon - 1);

> -	emv3020_set_reg(0x06, dt->tm_mon);
> +	emv3020_set_reg(0x06, dt->tm_mon + 1);

Why? (looks unrelated to the udelay() fixes as well)
