Return-Path: <linux-kernel-owner+w=401wt.eu-S1765140AbYBZXIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765140AbYBZXIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762820AbYBZXIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:08:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37217 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYBZXIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:08:23 -0500
Message-ID: <47C49BDD.50205@garzik.org>
Date: Tue, 26 Feb 2008 18:08:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>, romieu@fr.zoreil.com,
       sorbica@icplus.com.tw, jesse@icplus.com.tw,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC/PATCH] ipg: add jumbo frame support kconfig option
References: <Pine.LNX.4.64.0802262148270.12999@sbz-30.cs.Helsinki.FI> <20080226123247.2b63bbf0@extreme>
In-Reply-To: <20080226123247.2b63bbf0@extreme>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> Convert the internal JUMBO_FRAME #ifdef to CONFIG_IP1000_JUMBO_FRAME proper and
>> fix compilation errors.
>>
>> Cc: Francois Romieu <romieu@fr.zoreil.com>
>> Cc: Sorbica Shieh <sorbica@icplus.com.tw>
>> Cc: Jesse Huang <jesse@icplus.com.tw>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Please don't do this as a config option. Config options seem like a good idea
> to developers but are difficult for distributions.  Either support jumbo
> frames by default or not at all.

Agreed, but to be more specific...    always compile in jumbo frame 
support.  You don't have to enable it at runtime by default, though.

	Jeff



