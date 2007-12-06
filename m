Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbXLFXDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbXLFXDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXLFXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:02:56 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43531 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXLFXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:02:55 -0500
Message-ID: <47587F90.8010400@nortel.com>
Date: Thu, 06 Dec 2007 17:02:40 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org> <47586E7F.1020903@nortel.com> <20071206220754.GF20595@one.firstfloor.org>
In-Reply-To: <20071206220754.GF20595@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2007 23:02:44.0468 (UTC) FILETIME=[1C666B40:01C8385C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>>On a 1.4GHz P4 I measured a 44% increase in latency between a unix 
>>datagram and a UDP datagram.

> That's weird.

I just reran on a 3.2GHZ P4 running 2.6.11 (Fedora Core 4).  42% latency 
increase.

For stream sockets, unix gives approximately a 62% bandwidth increase 
over tcp.   (Although tcp could probably be tuned to do better than this.)

Chris
