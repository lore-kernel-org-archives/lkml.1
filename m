Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZJBSHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZJBSHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZJBSHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:07:41 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:48391
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbZJBSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:07:38 -0400
Message-ID: <4AC6507F.70303@microgate.com>
Date: Fri, 02 Oct 2009 13:11:59 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: lenrek@me.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/pcmcia/synclink_cs.c: BKL pushdown?
References: <060E5EC8-93F4-4AF1-889F-04A13378CB8D@me.com> <20091002124945.1814a2c3@lxorguk.ukuu.org.uk> <4AC5FE11.9060500@microgate.com> <0358338D-E697-4D44-96A8-E7107D50F77E@me.com> <4AC61D4E.4040000@microgate.com> <0DA1DE03-4131-4257-B476-03A776A9B4A6@me.com>
In-Reply-To: <0DA1DE03-4131-4257-B476-03A776A9B4A6@me.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lenrek@me.com wrote:
> On 2009/10/03, at 0:33, Paul Fulghum wrote:
> 
>> lenrek@me.com wrote:
>>> How about the BKL calls in synclinkmp.c, synclink.c, and  
>>> synclink_gt.c?
>>> Can they be safely eliminated?
>> I looked those over and yes, the BKL can be removed
>> from those as well. All 4 synclink drivers are mostly
>> variations on the same code.
>>
>> It looks like the lock_kernel calls were blindly pushed down
>> for safety during the initial transition, but all of the
>> functions covered either use device specific locking or
>> do not require locking.
> 
> Many thanks.  I enclose a patch against 2.6.31.1
> which eliminates the BKL calls from the synclink drivers.

Acked-by: Paul Fulghum <paulkf@microgate.com>

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
