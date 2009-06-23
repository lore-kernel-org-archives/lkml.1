Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZFWD0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZFWD0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZFWD00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:26:26 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:33875 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZFWD0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:26:25 -0400
Message-ID: <4A404B5F.80903@in.ibm.com>
Date: Tue, 23 Jun 2009 08:56:23 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] mm/init: cpu_hotplug_init() must be initialized before
 SLAB
References: <1245717089.4017.18.camel@pasglop> <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:
>
>   
>> +	/*
>> +	 * This initializes the mutex used by get/put_online_cpus()
>> +	 * which is used by SLAB
>> +	 */
>> +	cpu_hotplug_init();
>>     
>
> Oh fudge it.
>
> Why not get rid of that stupid thing, rather than have that subtle 
> dependency and a comment for it.
>
> IOW, does this simpler alternative also work?
This fixes the problem for me.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

