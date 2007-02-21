Return-Path: <linux-kernel-owner+w=401wt.eu-S1423258AbXBUX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423258AbXBUX1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423248AbXBUX1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:27:32 -0500
Received: from gw.goop.org ([64.81.55.164]:45165 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423261AbXBUX1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:27:31 -0500
Message-ID: <45DCD559.1040301@goop.org>
Date: Wed, 21 Feb 2007 15:27:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [patch 05/24] Xen-paravirt_ops: Add pagetable
 accessors to pack and unpack pagetable entries
References: <20070221205254.169835700@goop.org>	<20070221205322.869165491@goop.org>  <200702212315.12883.ak@suse.de> <1172100002.13378.42.camel@localhost.localdomain>
In-Reply-To: <1172100002.13378.42.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 2007-02-21 at 23:15 +0100, Andi Kleen wrote:
>   
>> On Wednesday 21 February 2007 21:52, Jeremy Fitzhardinge wrote:
>>     
>>> Add a set of accessors to pack, unpack and modify page table entries
>>> (at all levels).  This allows a paravirt implementation to control the
>>> contents of pgd/pmd/pte entries.  For example, Xen uses this to
>>> convert the (pseudo-)physical address into a machine address when
>>> populating a pagetable entry, and converting back to pphys address
>>> when an entry is read.
>>>       
>> Do you have some lmbench numbers before/after this change? 
>> iirc at least fork and exit do a lot of pte accesses in various forms.
>> If it's measurable it might be needed to patch those for the native case.
>>     
>
> Yes, __mkpte must be patched to avoid performance embarrassment.
>
> Jeremy, did you want me to do this, or are you happy to?
>   
I'm working on it now.  I'll mail out a proposal in a little bit.

    J
