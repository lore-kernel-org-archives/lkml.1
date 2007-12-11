Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXLKQPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXLKQPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXLKQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:15:46 -0500
Received: from il.qumranet.com ([82.166.9.18]:49769 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbXLKQPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:15:45 -0500
Message-ID: <475EB7AC.9040903@qumranet.com>
Date: Tue, 11 Dec 2007 18:15:40 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [RFC] Proposed new directory layout for kvm and virtualization
References: <475E5CBB.9080608@qumranet.com> <20071211161032.GA25769@uranus.ravnborg.org>
In-Reply-To: <20071211161032.GA25769@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Dec 11, 2007 at 11:47:39AM +0200, Avi Kivity wrote:
>   
>> KVM is due to receive support for multiple architectures (ppc, ia64, and 
>> s390, in addition to the existing x86), hopefully in time for the 2.6.25 
>> merge window.  It is awkward to place the new arch support in 
>> drivers/kvm/, so I'd like to propose the following new layout:
>>
>>  virt/         top-level directory for hypervisors
>>  virt/kvm/     kvm common code
>>  virt/lguest/  the other hypervisor
>>  arch/*/kvm/   arch dependent kvm code
>>     
>
> The arch/*/dir shall use same dir-name as used
> in top-level directory.
>   

Well, it isn't like that now (arch/x86/oprofile, etc.)

> So use arch/*/virt/kvm/ if kvm really requires
> a subdirectory of it own. Preferably not.
> A handful of files named kvm* does not warrant their own
> subdirectory IMO.
>
>   

We'll have 5-6 x86 specific files.

Where do you suggest we place them?


-- 
error compiling committee.c: too many arguments to function

