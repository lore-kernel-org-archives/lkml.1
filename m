Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbXLFXmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbXLFXmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXLFXmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:42:23 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:46533 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbXLFXmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:42:22 -0500
Message-ID: <475888D5.7010407@nortel.com>
Date: Thu, 06 Dec 2007 17:42:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org> <47586E7F.1020903@nortel.com> <20071206220754.GF20595@one.firstfloor.org> <47587F90.8010400@nortel.com> <20071206230611.GK20595@one.firstfloor.org>
In-Reply-To: <20071206230611.GK20595@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2007 23:42:16.0562 (UTC) FILETIME=[A2473D20:01C83861]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Dec 06, 2007 at 05:02:40PM -0600, Chris Friesen wrote:

>>I just reran on a 3.2GHZ P4 running 2.6.11 (Fedora Core 4).  42% latency 
>>increase.

> Sounds like something that should be looked into. I know of no
> principal reasons for that.

>>For stream sockets, unix gives approximately a 62% bandwidth increase 
>>over tcp.   (Although tcp could probably be tuned to do better than this.)

> How long a stream did you test? You might be measuring slow start.

No idea.  These are just the standard local networking tests in lmbench 
v2.  In our case the latency was the big concern and we were using 
datagrams anyway.

Chris
