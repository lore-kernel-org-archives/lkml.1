Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZEHTrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZEHTrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZEHTrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:47:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:41741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZEHTrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:47:12 -0400
Message-ID: <4A048C11.1050702@kernel.org>
Date: Fri, 08 May 2009 12:46:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <20090508111024.GD11596@elte.hu> <20090508124436.GT8112@parisc-linux.org>
In-Reply-To: <20090508124436.GT8112@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, May 08, 2009 at 01:10:24PM +0200, Ingo Molnar wrote:
>> ( Cc:-ed PCI folks. Original thread with patches is on lkml. There's
>>   a few details that affect non-Xen PCI code too - and it would be
>>   nice to see feedback on this general method as well, from the PCI 
>>   experts . )
> 
> I read over the top seven commits here:
> http://git.kernel.org/?p=linux/kernel/git/jeremy/xen.git;a=shortlog;h=xen-tip/dom0/pci
> and they all seem reasonable to me as far as they affect other code.
> I'm assuming that Xen people know what they're doing with respect to
> the Xen-only code ;-)

1. pcibios_set_cache_line_size looks could be __init
2. pci_xen_init and some xen_ function all for domU aka pv? that naming looks confusing.

YH
 

