Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbXCCU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbXCCU1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXCCU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:27:42 -0500
Received: from mail.tmr.com ([64.65.253.246]:56730 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbXCCU1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:27:41 -0500
Message-ID: <45E9DA80.2080109@tmr.com>
Date: Sat, 03 Mar 2007 15:28:48 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] libata: warn if speed limited due to 40-wire cable (v2)
References: <45DA44B4.6000209@shaw.ca>	<45E8B42E.7010900@garzik.org> <20070303005433.714d75ad@lxorguk.ukuu.org.uk>
In-Reply-To: <20070303005433.714d75ad@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> it seems broken to manipulate xfer_mask after returning from the 
>> driver's ->mode_filter hook.
>>
>> this patch is more than just a speed-limited warning printk, afaics
> 
> I actually suggested that order because the only way the printk can be
> done correctly is for it to be the very last test made. Since the mode
> filter is not told what mode will be used but just subtracts modes that
> are not allowed this should be safe.

Far better to have a drive which works slowly than one which works 
unreliably.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
