Return-Path: <linux-kernel-owner+w=401wt.eu-S1761244AbYDKQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbYDKQqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbYDKQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:45:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbYDKQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:45:59 -0400
Date: Fri, 11 Apr 2008 12:45:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
Message-ID: <20080411164542.GA4066@infradead.org>
References: <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com> <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org> <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FF9060.5040202@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 09:22:56AM -0700, Kok, Auke wrote:
> You don't provide a solution, nor does anyone, and I don't see any solution to
> what you want but to completely cancel this driver split.
> 
> And I'm _not_ going to do that.

As a start we could do two driver keyed off a single Kconfig variable.
And then find a way to get users informed that they might need to
enabled the other one
