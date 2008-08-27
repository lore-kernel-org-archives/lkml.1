Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYH0Gzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYH0Gzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYH0Gzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:55:42 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:41903 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYH0Gzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:55:41 -0400
Date: Wed, 27 Aug 2008 08:49:32 +0200 (CEST)
From: Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw.se.axis.com
To: David Woodhouse <dwmw2@infradead.org>
cc: Tim Anderson <tanderson@mvista.com>,
       "linux-mtd-bounces@lists.infradead.org" 
	<linux-mtd-bounces@lists.infradead.org>,
       "'Bruce Leonard'" <brucle@earthlink.net>,
       "Bruce_Leonard@selinc.com" <Bruce_Leonard@selinc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
In-Reply-To: <1219818923.7107.106.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0808270847350.17432@lnxricardw.se.axis.com>
References: <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
 <1219818923.7107.106.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 Aug 2008, David Woodhouse wrote:

> On Tue, 2008-08-26 at 23:20 -0700, Tim Anderson wrote:
>> I see your point. Ioctls are going away after all.
>>
>> So we should have something like:
>> /sys/class/mtd/mtd0/
>>
>> Or just under device or platform?
>
> Tim, please stop top-posting.
>
> I'm not sure I'd say I _vetoed_ new ioctls, but I certainly expressed a
> desire to do all the information stuff through sysfs. We would need a
> new MEMERASE64 ioctl though.

If the (lack of) sysfs stuff is standing between us and a nice >4GiB mtd I 
for one would think that a set of 64-bit ioctls would be a reasonable 
halfway house.

/Ricard
--
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
