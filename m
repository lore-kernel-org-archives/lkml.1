Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXBFJZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXBFJZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXBFJZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:25:10 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43982 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751877AbXBFJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:25:08 -0500
Message-ID: <45C84973.6060805@vmware.com>
Date: Tue, 06 Feb 2007 01:25:07 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
References: <200702060352.l163q87K000713@zach-dev.vmware.com>	 <1170736029.29293.31.camel@localhost.localdomain>	 <45C809F9.2090905@vmware.com>	 <1170738676.29293.35.camel@localhost.localdomain> <1170752856.7324.5.camel@laptopd505.fenrus.org>
In-Reply-To: <1170752856.7324.5.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 2007-02-06 at 16:11 +1100, Rusty Russell wrote:
>   
>> On Mon, 2007-02-05 at 20:54 -0800, Zachary Amsden wrote:
>>     
>>> Rusty Russell wrote:
>>>       
>>>> Indeed, I'm expecting to push lguest this week, and this code will
>>>> effect me, so I'd like to see this in a -mm soon...
>>>>         
>>> Yes, I took a look at the lguest changes today and I think these won't 
>>> generate conflicts, just make stuff easier for you ;)  Course you've now 
>>> got a couple new paravirt-ops to support, but the native ones are fine 
>>> for temporary use.
>>>       
>> Implementing stolen time is something I'd like to do, since it'd be a
>> nice self-contained example the expectations.
>>     
>
>
> hmm stolen time could even be useful without virtualization; to a large
> degree, if cpufreq reduces the speed of your cpu you have "stolen
> cycles" that way... I wonder if this concept can be used for that as
> well...
>   

Yes, stolen time happens in most moderns systems as a result of power 
management (and you can probably count SMM cycles as stolen if only 
there was a way to count them).  It would be useful to report on a 
laptop, for instance, how many cycles have been stolen by running off 
battery or on a server because of heat issues.  Having an interface for 
Linux to report this seems useful.  It is a covert channel, however, in 
a virtualized environment, so there should be some provision in the 
hypervisor to turn it off.

Zach
