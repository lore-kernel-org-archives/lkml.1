Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbXLGEV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbXLGEV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbXLGEVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:21:49 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:34063 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbXLGEVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:21:49 -0500
Message-ID: <4758CA53.7000407@nortel.com>
Date: Thu, 06 Dec 2007 22:21:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andi@firstfloor.org, renzo@cs.unibo.it, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org>	<47585D66.3000404@nortel.com> <20071206.194131.79623068.davem@davemloft.net>
In-Reply-To: <20071206.194131.79623068.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2007 04:21:43.0247 (UTC) FILETIME=[AC0055F0:01C83888]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Chris Friesen" <cfriesen@nortel.com>
> Date: Thu, 06 Dec 2007 14:36:54 -0600
> 
> 
>>One problem we ran into was that there are only 32 multicast groups per 
>>netlink protocol family.
> 
> 
> I'm pretty sure we've removed this limitation.

As of 2.6.23 nl_groups is a 32-bit bitmask with one bit per group. 
Also, it appears that only root is allowed to use multicast netlink.

Chris
