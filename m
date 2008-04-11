Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYDKXy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYDKXy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYDKXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:54:48 -0400
Received: from mail.lang.hm ([64.81.33.126]:34199 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbYDKXyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:54:47 -0400
Date: Fri, 11 Apr 2008 16:58:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Jeff Garzik <jeff@garzik.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Barkalow <barkalow@iabervon.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
In-Reply-To: <47FFF7B5.3000609@garzik.org>
Message-ID: <alpine.DEB.1.10.0804111655520.6058@asgard>
References: <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org>
 <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org> <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <alpine.LNX.1.00.0804111700550.19665@iabervon.org> <alpine.LFD.1.00.0804111556200.3143@woody.linux-foundation.org>
 <47FFF7B5.3000609@garzik.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Jeff Garzik wrote:

> Linus Torvalds wrote:
>> .. but that said, I think your patch is certainly better than what we have 
>> now (or what Ingo was complaining about for the next merge window). I 
>> certainly could live with it. I would just suggest against ever then 
>> removing that "generic E1000" choice.
>
>
> You mean never ever remove PCI-E support from e1000?
>
> Won't that will inflict long term headaches on the people that matter most -- 
> users and maintainers -- to avoid short term headaches for kernel power 
> users?

no, it sounds like he's saying make the E1000 option select both E1000_PCI 
and E1000_PCIE (which could be selected seperately) and never remove the 
E1000 option.

after people trust the E1000e driver the PCI ids can be removed from 
E1000, but people who only select E1000 will continue to work becouse the 
build system will now build both the PCI and PCI-e drivers when E1000 is 
selected.

David Lang

