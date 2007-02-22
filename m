Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXBVKlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXBVKlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbXBVKlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:41:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:37496 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXBVKlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:41:39 -0500
Message-ID: <45DD7330.1030001@qumranet.com>
Date: Thu, 22 Feb 2007 12:40:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
 a	central arch-independent location
References: <45D979D3.2020907@qumranet.com>	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>	 <45DD6CF0.3010509@qumranet.com>	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net> <1172140490.3531.236.camel@laptopd505.fenrus.org>
In-Reply-To: <1172140490.3531.236.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> I have Ingo's network PV hypercalls to commit in my piplien.
>>     
>
> I have 5 or so pending as well :)
> can't wait for the infrastructure to be there so that it's relatively
> easy to add my paravirt block driver
>   

I can't wait for your pv block driver :)

What do you think is missing?  My list has:

- registration of hypercall handlers from modules
- execution of hypercall handlers outside vcpu_load() (so they are 
preemptible and sleepable)
- passing unhandled hypercalls to userspace for qemu-based devices

Please do post the patches to kvm-devel, even if they aren't ready, so 
we can get a taste of what's coming.

-- 
error compiling committee.c: too many arguments to function

