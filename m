Return-Path: <linux-kernel-owner+w=401wt.eu-S934073AbXDDTWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbXDDTWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934069AbXDDTWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:22:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10539 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073AbXDDTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:22:10 -0400
Message-ID: <4613FB13.7010709@oracle.com>
Date: Wed, 04 Apr 2007 12:22:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
References: <11757099691323-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <20070404120025.4c5548dc.randy.dunlap@oracle.com> <200704041213.52777.david-b@pacbell.net>
In-Reply-To: <200704041213.52777.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Wednesday 04 April 2007 12:00 pm, Randy Dunlap wrote:
>> On Wed,  4 Apr 2007 14:05:04 -0400 Tony Lindgren wrote:
>>
>>> +static int __init fpga_init(void)
>>> +{
>>> +	if (machine_is_omap_h4()
>>> +			|| machine_is_omap_h3()
>>> +			|| machine_is_omap_h2()
>>> +			|| machine_is_omap_perseus2()
>>> +			)
>> Perhaps there is nothing in CodingStyle for if () continuation
>> lines.  Looks like it is needed.  This is ETOOMUCHINDENTATION by
>> at least one tab.  Should be more like:
>>
>> +	if (machine_is_omap_h4()
>> +	    || machine_is_omap_h3()
>> +	    || machine_is_omap_h2()
>> +	    || machine_is_omap_perseus2())
> 
> That's clearly wrong -- it uses non-tab characters for indents.

That first part is not clear at all.

> Which means that unless you think
> 
> 	if (this_longthing
> 		|| that longthing
> 		|| another
> 		...)
> 		the condition;
> 
> is correct (nope!), those additional conditions need more indents.

No, that's still ugly.

>> (without getting into where the "||" should be placed).
>>
>>> +		return platform_driver_register(&led_driver);
>>> +	return 0;
>>> +}
>>> +fs_initcall(fpga_init);
>> fs, eh?
> 
> That basically means "after subsys init and before other drivers", yes?
> For platform level init code, that's a fairly significant category.

Maybe it should have an alias then?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
