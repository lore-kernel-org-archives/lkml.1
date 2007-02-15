Return-Path: <linux-kernel-owner+w=401wt.eu-S965775AbXBOKT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965775AbXBOKT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965773AbXBOKT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:19:28 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54682 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965771AbXBOKT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:19:27 -0500
Message-ID: <45D433AC.7030809@pobox.com>
Date: Thu, 15 Feb 2007 05:19:24 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sk98lin: planned removal
References: <20070207091830.59f72f46@oldman> <20070207203215.bdf3908b.akpm@linux-foundation.org>
In-Reply-To: <20070207203215.bdf3908b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 7 Feb 2007 09:18:30 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> 
>> Document planned removal of sk98lin driver.
>>
>> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
>> ---
>>  Documentation/feature-removal-schedule.txt |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>> index 0ba6af0..d08a4af 100644
>> --- a/Documentation/feature-removal-schedule.txt
>> +++ b/Documentation/feature-removal-schedule.txt
>> @@ -325,3 +325,10 @@ Why:	Unmaintained for years, superceded 
>>  Who:	Jeff Garzik <jeff@garzik.org>
>>  
>>  ---------------------------
>> +
>> +What:   sk98lin network driver
>> +When:   July 2007
>> +Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
>> +	replaced by the skge driver. 
>> +Who:    Stephen Hemminger <shemminger@osdl.org>
>> +
> 
> People don't read that file.  I'd suggest the addition of a warning printk
> to the driver's open() method.

Fine with me.  Stephen, wanna cook up a patch?

	Jeff



