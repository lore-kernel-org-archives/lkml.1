Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbXGXFXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbXGXFXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXGXFXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:23:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:43531 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXGXFXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:23:07 -0400
Message-ID: <46A58CAD.7070807@qumranet.com>
Date: Tue, 24 Jul 2007 08:22:53 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/8]KVM: swap out guest pages
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com> <20070723200659.GA13508@c2.user-mode-linux.org>
In-Reply-To: <20070723200659.GA13508@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 24 Jul 2007 08:22:53 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Mon, Jul 23, 2007 at 01:27:40PM +0300, Avi Kivity wrote:
>   
>> Having an address_space (like your patch does) is remarkably simple, and 
>> requires few hooks from the current vm.  However using existing vmas 
>> mapped by the user has many advantages:
>>     
>
> It's also needed for a SKAS-like UML client, where the host side will
> need to make system calls on behalf of the guest.
>
>   

Even in the current model, guest physical memory is mmap()ed into host
userspace.  The kernel cannot enforce this, however.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

