Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXCVFFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXCVFFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965748AbXCVFFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:05:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965724AbXCVFFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:05:07 -0400
Date: Thu, 22 Mar 2007 01:02:50 -0400
From: Dave Jones <davej@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070322050250.GC17159@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Willy Tarreau <w@1wt.eu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andi Kleen <andi@firstfloor.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>
References: <20070320165736.GA19781@redhat.com> <20070320181442.1ae73295@lxorguk.ukuu.org.uk> <20070321151952.02b5612d.akpm@linux-foundation.org> <20070322001050.13588e5e@lxorguk.ukuu.org.uk> <20070321161341.0f87ed60.akpm@linux-foundation.org> <20070321232433.GX943@1wt.eu> <20070321234318.GE9092@redhat.com> <20070322041242.GA29741@1wt.eu> <20070322041751.GB17159@redhat.com> <20070322044540.GA32191@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322044540.GA32191@1wt.eu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 05:45:40AM +0100, Willy Tarreau wrote:
 > On Thu, Mar 22, 2007 at 12:17:51AM -0400, Dave Jones wrote:
 > > On Thu, Mar 22, 2007 at 05:12:42AM +0100, Willy Tarreau wrote:
 > >  > On Wed, Mar 21, 2007 at 07:43:18PM -0400, Dave Jones wrote:
 > >  > > On Thu, Mar 22, 2007 at 12:24:33AM +0100, Willy Tarreau wrote:
 > >  > >  
 > >  > >  > Then a printk() on every open() should be enough. We've all been seeing
 > >  > >  > "Warning: tcpdump uses obsolete AF_PACKET"... and it finally disappeared.
 > >  > > 
 > >  > > There's a difference.  We have the source for tcpdump.
 > >  > 
 > >  > But what's the problem with "warning: process XXX uses obsolete raw driver
 > >  > and may not work anymore after 2007/XX/XX if not fixed" ?
 > > 
 > > The target audience isn't going to read it.
 > 
 > Yes they will if you write it with KERN_CRIT.

*no*.

Users will see it. The developers of the software those users are running won't.
We're talking about apps here that we don't have the source to, and vendors
want extortionate amount of money to change.

	Dave

-- 
http://www.codemonkey.org.uk
