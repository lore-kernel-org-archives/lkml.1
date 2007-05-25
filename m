Return-Path: <linux-kernel-owner+w=401wt.eu-S1765046AbXEYU27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765046AbXEYU27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbXEYU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:28:50 -0400
Received: from lollipop.listbox.com ([208.210.124.78]:53786 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbXEYU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:28:50 -0400
In-Reply-To: <200705250751.45738.ak@suse.de>
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <20070524213157.1d39458f.akpm@linux-foundation.org> <200705250751.45738.ak@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <036B6511-FC30-4F81-98E7-C86F6993D618@lundell-bros.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@ninex.eu.org>, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Jonathan Lundell <linux@lundell-bros.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Date: Fri, 25 May 2007 13:16:57 -0700
To: Andi Kleen <ak@suse.de>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 24, 2007, at 10:51 PM, Andi Kleen wrote:

>> Do we have a feel for how much performace we're losing on those
>> systems which _could_ do MSI, but which will end up defaulting
>> to not using it?
>
> At least on 10GB ethernet it is a significant difference; you usually
> cannot go anywhere near line speed without MSI
>
> I suspect it is visible on high performance / multiple GB NICs too.

Why would that be? As the packet rate goes up and NAPI polling kicks  
in, wouldn't MSI make less and less difference?

I like the fact that MSI gives us finer control over CPU affinity  
than many INTx implementations, but that's a different issue.

