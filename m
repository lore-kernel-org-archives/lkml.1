Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZJAImR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZJAImR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZJAImQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:42:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56723 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZJAImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:42:15 -0400
Message-ID: <4AC46B20.6020300@nokia.com>
Date: Thu, 01 Oct 2009 11:41:04 +0300
From: Roger Quadros <ext-roger.quadros@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] twl4030: Fix boot with twl4030 usb transceiver enabled
References: <1254385536-26912-1-git-send-email-ext-roger.quadros@nokia.com> <1254386189.32310.20.camel@localhost>
In-Reply-To: <1254386189.32310.20.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2009 08:41:44.0099 (UTC) FILETIME=[011F6F30:01CA4273]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Thu, 2009-10-01 at 11:25 +0300, Roger Quadros wrote:
>>  	if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
>>  		child = add_child(3, "twl4030_bci",
>> @@ -532,16 +531,61 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>>  	}
>>  
>>  	if (twl_has_usb() && pdata->usb) {
>> +
> Why is this extra line?
> 
>> +		static struct regulator_consumer_supply usb1v5 = {
>> +			.supply =	"usb1v5",
>> +		};
> 

oops, my bad. and checkpatch didn't point it out ;)
