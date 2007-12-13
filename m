Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXLMIeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXLMIeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXLMIdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:33:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:40302 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbXLMIdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:33:51 -0500
Message-ID: <4760EE69.2090006@qumranet.com>
Date: Thu, 13 Dec 2007 10:33:45 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: kvm-devel@lists.sourceforge.net,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC] Proposed new directory layout for kvm and virtualization
References: <475E5CBB.9080608@qumranet.com> <20071211151143.GA7751@osiris.boeblingen.de.ibm.com> <475EB23E.1060002@qumranet.com> <200712120014.43314.arnd@arndb.de>
In-Reply-To: <200712120014.43314.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 11 December 2007, Avi Kivity wrote:
>   
>> Heiko Carstens wrote:
>>     
>>> On Tue, Dec 11, 2007 at 11:47:39AM +0200, Avi Kivity wrote:
>>>
>>>       
>>>>  arch/*/kvm/   arch dependent kvm code
>>>>     
>>>>         
>>> Maybe arch/*/virt/ ? No need to add an own directory for each hypervisor.
>>>
>>>       
>> There will be several kvm files in that directory for x86. If you have 
>> just one file, I guess arch/*/virt/kvm.c is okay.
>>     
>
> In that case, even arch/*/{mm,kernel}/kvm.c would work fine, as long as you
> only want to support one hypervisor, or a small set of small files, there
> is no need to have even have a virt directory.
>
> However, if you want to have symmetry across the architectures, I think
> arch/*/kvm/ works out best, along the lines of 
> arch/*/{perfmon,crypto,xen,power}. Neither of these is particularly large,
> but arch/* is typically not that crowded either.
>   

In the case of x86, we'll have 16 arch dependent files (i8259.[ch], 
irq.[ch], lapic.c, mmu.c, paging_tmpl.[ch], svm.[ch], vmx.[ch], 
x86.[ch], x86_emulate.[ch]) which warrant a kvm/ subdirectory IMO.

-- 
error compiling committee.c: too many arguments to function

