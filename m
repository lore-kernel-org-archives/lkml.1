Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbXLKRmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbXLKRmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXLKRmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:42:31 -0500
Received: from il.qumranet.com ([82.166.9.18]:35180 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbXLKRma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:42:30 -0500
Message-ID: <475ECC04.8000609@qumranet.com>
Date: Tue, 11 Dec 2007 19:42:28 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [RFC] Proposed new directory layout for kvm and virtualization
References: <475E5CBB.9080608@qumranet.com> <20071211161032.GA25769@uranus.ravnborg.org> <475EB7AC.9040903@qumranet.com> <20071211173717.GA26368@uranus.ravnborg.org>
In-Reply-To: <20071211173717.GA26368@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>
>>> So use arch/*/virt/kvm/ if kvm really requires
>>> a subdirectory of it own. Preferably not.
>>> A handful of files named kvm* does not warrant their own
>>> subdirectory IMO.
>>>
>>>  
>>>       
>> We'll have 5-6 x86 specific files.
>>
>> Where do you suggest we place them?
>>     
> /arch/x86/virt/
>
>   

But, I want to place the arch independent files in virt/kvm/, so as to 
leave room for virt/lguest/.

> Seems logical and fit the way we handle mm/ versus arch/*/mm,
> kernel/ arch/*/kernel etc.
>   

Exactly, so virt/kvm/ -> arch/x86/virt/kvm/.

> Are there any dependencies between the arch and non-arch files
> such as they are combined in a single module?
>
>   

Yes, they are combined into a single module.

In the case of x86, some of arch/x86/... will be combined with virt/kvm/ 
to form kvm.ko, while others will generate kvm-intel.ko and kvm-amd.ko.

-- 
error compiling committee.c: too many arguments to function

