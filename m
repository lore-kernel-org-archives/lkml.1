Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXGBTBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXGBTBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbXGBTBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:01:33 -0400
Received: from mail.tmr.com ([64.65.253.246]:48433 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbXGBTBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:01:32 -0400
Message-ID: <46894BD5.9080609@tmr.com>
Date: Mon, 02 Jul 2007 15:02:45 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       saw@saw.sw.com.sg
Subject: Re: [2.6 patch] the overdue eepro100 removal
References: <20070701202139.GM10869@stusta.de>
In-Reply-To: <20070701202139.GM10869@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the overdue removal of the eepro100 driver.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
The hardware supported by this driver is still in use, thanks. It's 
probably easier to leave the eepro100 driver in than find anyone who 
wants to investigate why the other driver (e100? from memory) doesn't 
work with some cards. As I recall this was suggested over a year ago and 
it was decided to leave it in, all of the reasons for doing so still 
seem valid. There really doesn't seem to be a benefit, it's not like 
people are working night and day to support new cards for this chip.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
