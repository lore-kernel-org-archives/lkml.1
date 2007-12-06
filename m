Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbXLFVuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbXLFVuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXLFVuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:50:06 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:60544 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXLFVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:50:05 -0500
Message-ID: <47586E7F.1020903@nortel.com>
Date: Thu, 06 Dec 2007 15:49:51 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org>
In-Reply-To: <20071206212644.GA26725@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2007 21:49:55.0039 (UTC) FILETIME=[F00476F0:01C83851]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>Latency was very 
>>important, so we ended up doing essentially a multicast unix socket 
>>rather than taking the extra penalty for UDP multicast.
> 
> 
> What extra penalty? Local UDP shouldn't be much more expensive than Unix.

On a 1.4GHz P4 I measured a 44% increase in latency between a unix 
datagram and a UDP datagram.

For UDP it has to go down the udp stack, then the ip stack, then through 
the routing tables and back up the receive side.

The unix socket just hashes to get the destination and delivers the message.

Chris
