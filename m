Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZDTDOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZDTDOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 23:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZDTDOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 23:14:07 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:28213
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbZDTDOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 23:14:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogBACeF60l8qMtz/2dsb2JhbAAIy2+DfQY
X-IronPort-AV: E=Sophos;i="4.40,214,1238947200"; 
   d="scan'208";a="470617696"
Subject: Re: [PATCH] favr32: improve touchscreen response
From: Ben Nizette <bn@niasdigital.com>
To: "haavard.skinnemoen" <haavard.skinnemoen@atmel.com>
Cc: kernel <kernel@avr32linux.org>,
       "Egtvedt, Hans-Christian" <Hans-Christian.Egtvedt@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1240195013.24329.38.camel@linux-51e8.site>
References: <1240195013.24329.38.camel@linux-51e8.site>
Content-Type: text/plain; charset=utf-8
Date: Mon, 20 Apr 2009 13:13:34 +1000
Message-Id: <1240197214.30294.1.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 12:36 +1000, Ben Nizette wrote:
> +	.keep_vref_on		= true,
> +	.settle_delay_usecs	= 500,
> +	.penirq_recheck_delay_usecs = 100,
>  
>  	/* The ads7843 pendown irq is just connected to regular
>  	 * gpio and therefore can only trigger interrupts on

Whoops, looks like this applies on top of

﻿[PATCH] ads7846: Allow both-edge interrupt mode

Sorry.  Let us know if you want me to rebase :-)

	--Ben.


