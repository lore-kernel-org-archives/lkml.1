Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbYDKVIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbYDKVIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbYDKVHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:07:52 -0400
Received: from mail.ttlc.net ([66.94.32.4]:3372 "EHLO mail.ttlc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760704AbYDKVHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:07:51 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2008 17:07:51 EDT
Message-ID: <47FFD192.6060707@isomerica.net>
Date: Fri, 11 Apr 2008 17:01:06 -0400
From: Dan Noe <dpn@isomerica.net>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
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
References: <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org> <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org> <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <20080411175304.GF11962@parisc-linux.org> <alpine.LFD.1.00.0804111146450.3143@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804111146450.3143@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2008 14:51, Linus Torvalds wrote:
> Nobody wants to care deeply whether it's a PCI-E or PCI chip. In fact, 
> it's almost impossible to tell. Here, quickly, tell me which one mine is 
> (this is from /sbin/lspci):
> 
> 	00:19.0 Ethernet controller: Intel Corporation 82566DM Gigabit Network Connection (rev 02)
> 
> and tell me how you knew..

lspci -vv will tell you (if you're root :)!

Yet, the only part of that output that makes it even somewhat obvious is 
the "Link: Speed 2.5Gb/s, Width x1" which clearly makes no sense for 
legacy PCI.

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noe
                     |  http://isomerica.net/~dpn/

