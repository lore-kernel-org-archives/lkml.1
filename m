Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXLFUhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXLFUhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXLFUhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:37:11 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:56851 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbXLFUhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:37:10 -0500
Message-ID: <47585D66.3000404@nortel.com>
Date: Thu, 06 Dec 2007 14:36:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org>
In-Reply-To: <20071206163538.GC20595@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2007 20:36:57.0579 (UTC) FILETIME=[BED913B0:01C83847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>"This document describes Linux Netlink, which is used in Linux both as
>>   an intra-kernel messaging system as well as between kernel and user
>>   space."
> 
> 
> It can be used between user space daemons as well. In fact it is.
> e.g. they often listen to each other's messages.

One problem we ran into was that there are only 32 multicast groups per 
netlink protocol family.

We had a situation where we could have used netlink, but we needed the 
equivalent of thousands of multicast groups.  Latency was very 
important, so we ended up doing essentially a multicast unix socket 
rather than taking the extra penalty for UDP multicast.

Chris
