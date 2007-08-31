Return-Path: <linux-kernel-owner+w=401wt.eu-S965173AbXHaMw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965173AbXHaMw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 08:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964955AbXHaMwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 08:52:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41315 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964913AbXHaMwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 08:52:20 -0400
Message-ID: <46D80EF9.7000300@garzik.org>
Date: Fri, 31 Aug 2007 08:52:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [RFC][PATCH] uli526x: Add suspend and resume routines (updated)
References: <200708052114.01790.rjw@sisk.pl> <200708080056.41651.rjw@sisk.pl> <46C14479.1080206@garzik.org> <200708142009.03272.rjw@sisk.pl>
In-Reply-To: <200708142009.03272.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 14 August 2007 07:58, Jeff Garzik wrote:
>> Rafael J. Wysocki wrote:
>>> On Wednesday, 8 August 2007 00:26, Jeff Garzik wrote:
>>>> Rafael J. Wysocki wrote:
>>>>> On Tuesday, 7 August 2007 23:40, Jeff Garzik wrote:
>>>>>> I'll let our new tulip maintainer see what he thinks about the 
>>>>>> implementation.  Seems fairly sane to me, but should at least get an "it 
>>>>>> works" test.
>>>>> It has been tested, as stated in the changelog, and works (on my test system).
> [--snip--]
>  
>> Two comments:
>>
>> 1) Like akpm, the CONFIG_PM_SLEEP is out of place.  All other drivers 
>> use CONFIG_PM
> 
> OK
> 
>> 2) just remove the !dev checks, that is an impossible condition
> 
> OK
> 
> Updated patch follows.
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add suspend/resume support to the uli526x network driver (tested on x86_64,
> with 'Ethernet controller: ALi Corporation M5263 Ethernet Controller, rev 40').
> 
> This patch is based on the suspend/resume code in the tg3 driver.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/net/tulip/uli526x.c |  108 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 102 insertions(+), 6 deletions(-)

applied


