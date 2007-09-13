Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbXIMEA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbXIMEA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695AbXIMEAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:00:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40630 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbXIMEAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:00:11 -0400
Message-ID: <46E8B5C7.8060804@garzik.org>
Date: Thu, 13 Sep 2007 00:00:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Hayim Shaul <hayim@iportent.com>
CC: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       edward_peng@dlink.com.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.18-rc6 1/2] dllink driver: porting v1.19 to linux
 2.6.18-rc6
References: <1157620189.2904.16.camel@localhost.localdomain>
In-Reply-To: <1157620189.2904.16.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hayim Shaul wrote:
> Description:
> For DLink Fiber NIC, Linux 2.4.22 ships with driver version 1.19,
> whereas, Linux 2.6.x ship with driver version 1.17.
> 
> The following patch upgrades the 2.6.x driver to include changes (and
> bug fixes done until 1.19b).
> 
> These fixes are (copied from the driver):
>     1.18    2002/11/07  New tx scheme, adaptive tx_coalesce.
>                     Remove tx_coalesce option.
>     1.19    2003/12/16  Fix problem parsing the eeprom on big endian
>                     systems. (philt@4bridgeworks.com)
> 
> Disclaimer:
> Since I returned my DLink NIC to the store I couldn't test it
> thoroughly. It seemed to work just as well as v1.17. However, both
> version made the NIC hang after a few minutes.

Please update to the latest upstream kernel (2.6.22 or 2.6.23-rc).

Also, please make sure you do not back out changes included in the 
upstream kernel since 2.6.17.


