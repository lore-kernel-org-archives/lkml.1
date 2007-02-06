Return-Path: <linux-kernel-owner+w=401wt.eu-S965424AbXBFAsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbXBFAsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965421AbXBFAso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:48:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51336 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965411AbXBFAsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:48:33 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 6 Feb 2007 01:48:25 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ohci1394 broke 2.6.19 -> 2.6.20-rc1
To: Robert Crocombe <rcrocomb@gmail.com>
cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <tkrat.f2510ec744e6b5c8@s5r6.in-berlin.de>
Message-ID: <tkrat.064c609db01a3918@s5r6.in-berlin.de>
References: <e6babb600702051521l4a08eb2dw2a7f423fd0d7edd7@mail.gmail.com>
 <tkrat.c39467d7194502c4@s5r6.in-berlin.de>
 <tkrat.f2510ec744e6b5c8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> @@ -1132,6 +1132,7 @@ static int __init ieee1394_init(void)
>  		}
>  	}
>  
> +	ret = driver_register(&nodemgr_mid_layer_driver);
>  	ret = class_register(&hpsb_host_class);
>  	if (ret < 0)
>  		goto release_all_bus;

I think I make that a
	WARN_ON(driver_register(&nodemgr_mid_layer_driver));
-- 
Stefan Richter
-=====-=-=== --=- --==-
http://arcgraph.de/sr/


