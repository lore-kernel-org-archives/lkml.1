Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbXIBQ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbXIBQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 12:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXIBQ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 12:57:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56833 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbXIBQ5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 12:57:01 -0400
Message-ID: <46DAEB58.3070109@garzik.org>
Date: Sun, 02 Sep 2007 12:56:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/x86-64 PCI domain support
References: <20070901143223.GA32216@havoc.gtf.org>	<200709020000.03375.ak@suse.de>	<46D9E254.6010702@garzik.org>	<200709020026.52725.ak@suse.de>	<46D9EA5B.9010101@garzik.org> <20070902094637.6750f068.randy.dunlap@oracle.com>
In-Reply-To: <20070902094637.6750f068.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 01 Sep 2007 18:40:27 -0400 Jeff Garzik wrote:
> 
>> Andi Kleen wrote:
>>>>> The second function is redundant? 
>>>> No, it's a hook we must implement, when CONFIG_PCI_DOMAINS is enabled.
>>> Then the other function is redundant.
>> No, both functions are required by the interface.
> 
> by what interface?  and why, please?  (instead of just stating "required")

grep for CONFIG_PCI_DOMAINS in arch code and include/linux/pci.h.

This is normal "arch" interface:  you enable a define, and a group of 
functions is assumed to be present.  Otherwise (!defined), a set of stub 
no-ops is activated for your arch.

I have implemented the [small] group of functions the code assumes to be 
present, when CONFIG_PCI_DOMAINS is enabled, like all the other arches 
that implement PCI domain support.

	Jeff



