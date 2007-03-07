Return-Path: <linux-kernel-owner+w=401wt.eu-S1161076AbXCGAyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161076AbXCGAyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161077AbXCGAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:54:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:9383 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161076AbXCGAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:54:41 -0500
Message-ID: <45EE0D4E.3060903@codemonkey.ws>
Date: Tue, 06 Mar 2007 18:54:38 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
References: <45ED82D9.6050204@codemonkey.ws>	 <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com>	 <20070306203712.GC21736@elte.hu> <1173228246.4644.85.camel@localhost.localdomain>
In-Reply-To: <1173228246.4644.85.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-03-06 at 21:37 +0100, Ingo Molnar wrote:
>   
>> maybe i shouldnt call it 'VMI' but 'the paravirt ABI'. I dont mind if 
>> it's the Xen ABI or the VMWare ABI or a mesh of the two - everyone can 
>> map their own internals to that /one/ ABI.
>>     
>
> I think it's an excellent aim, but it's *HARD*.  I rejected this
> approach earlier because I'm just not smart enough.  (Yet?)
>
> The Linux side is fairly stable.  The hardware side is changing, and the
> hypervisor side is changing.  This means the ABI will churn fairly fast.
> The hypervisors are very different, which means the ABI will be very
> wide.
>
> We could start with VMI and try to support Xen, KVM and lguest.

There is one more here.  We also have Xen HVM which will soon want to be 
paravirtualized too.  We don't want the current xen paravirt_ops for 
that as they have a lot of things that HVM does not need.

Since KVM and Xen HVM have the least requirements in term of guest 
modifications, they are probably the obviously places to start.

Regards,

Anthony Liguori

>   It
> would at least give us a better idea of the scope of the problem.  But
> IMHO it's a *huge* job.
>
> Rusty.
>
>
>
>   

