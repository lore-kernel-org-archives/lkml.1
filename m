Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbYARPDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbYARPDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbYARPDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:03:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYARPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:03:46 -0500
Message-ID: <4790BD90.9060303@zytor.com>
Date: Fri, 18 Jan 2008 09:54:08 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Ian Campbell <ijc@hellion.org.uk>, "Huang, Ying" <ying.huang@intel.com>,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
 bt_ioremap - enhance bt_ioremap
References: <1200375906.3505.30.camel@caritas-dev.intel.com>	 <1200646105.17230.28.camel@cthulhu.hellion.org.uk> <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com>
In-Reply-To: <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
> 
> If CONFIG_X86_PAE is defined, the set_pte, clear_pte etc will operate
> 3-level page tables, while on i386, the early page table is always
> 2-level, so set_pte, clear_pte etc functions can not be used here. The
> boot_ioremap use a trick to deal with this problem. The CONFIG_X86_PAE
> is undefined in arch/x86/mm/boot_ioremap_32.c unconditionally, so the
> 2-level page table handling function is always used.
> 
> Is the method used by boot_ioremap better for Xen?
> 

Eric Biederman had a patchset that makes a PAE kernel use PAE page 
tables from the start.  That is really The Right Thing[TM].

	-hpa
