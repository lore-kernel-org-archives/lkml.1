Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbXA2RnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbXA2RnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbXA2RnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:43:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:10003 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXA2RnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:43:22 -0500
Message-ID: <45BE31E7.6070802@mvista.com>
Date: Mon, 29 Jan 2007 07:41:59 -1000
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-pm@lists.osdl.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] PM: fast power off - driver
References: <45BBB09C.7020509@mvista.com> <20070128100956.77509585.randy.dunlap@oracle.com>
In-Reply-To: <20070128100956.77509585.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Randy Dunlap wrote:
> On Sat, 27 Jan 2007 10:05:48 -1000 akuster wrote:
> 
>> My apologies, I cc'd the wrong list the first time around.
> 
> 
> +config FAST_POWER_DOWN
> +	tristate "Fast power of profile"
> ---------------------------> off
> 	What does that mean?  especially the "profile" part?
> 
> +	depends on FAST_POWER_OFF
> 
> 
> +	printk(KERN_INFO "PM: Fastpoweroff, %s profile added\n",fpo_default.name);
> 
> Space after "," please.

will correct

> 
> 
> OK, let me see if I understand fsd_default_off().
> 

<snipped.

> 
> Does this say (2) power off the system and then (3) power off devices?
yes,
> How does it power off devices after calling fastpoweroff()?

It does not, it was only a last ditch effort before losing power. I was 
on the fence whether to include that, easy to remove.

> Or is fastpoweroff() only setting the stage for something to
> happen later?

Nope.

Thanks for you time.
- Armin


