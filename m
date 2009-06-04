Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZFDPPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZFDPPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZFDPPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:15:19 -0400
Received: from stinky.trash.net ([213.144.137.162]:34632 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbZFDPPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:15:17 -0400
Message-ID: <4A27E505.9070108@trash.net>
Date: Thu, 04 Jun 2009 17:15:17 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       sfr@canb.auug.org.au, slapin@ossfans.org
Subject: Re: [PATCH 4/6] net: add NL802154 interface for configuration of
 	802.15.4 devices
References: <1244021629-18409-4-git-send-email-dbaryshkov@gmail.com>	 <1244021629-18409-5-git-send-email-dbaryshkov@gmail.com>	 <1244021964.10665.5.camel@johannes.local>	 <20090603.030911.162861804.davem@davemloft.net>	 <20090603105256.GB20508@doriath.ww600.siemens.net>	 <1244027110.1693.9.camel@johannes.local>	 <20090603122744.GC20508@doriath.ww600.siemens.net>	 <1244124749.22576.71.camel@johannes.local>	 <bc64b4640906040751i3c64c317i4eedb7d53307092a@mail.gmail.com>	 <4A27E448.3040305@trash.net> <bc64b4640906040814m1756ea13s19e20592ecf90e9b@mail.gmail.com>
In-Reply-To: <bc64b4640906040814m1756ea13s19e20592ecf90e9b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Eremin-Solenikov wrote:
> 2009/6/4 Patrick McHardy <kaber@trash.net>:
>> canceling messages is only necessary in fill functions that are
>> also used for dumps, where as many elements are stuffed in the
>> skb as possible. When the last element doesn't completely fit,
>> its removed again (canceled) and put into the next skb.
> 
> Understood. So you'd suggest just to drop the genlmsg_cancel()
> from the failure call chain?

Yes.

