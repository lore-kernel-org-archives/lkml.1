Return-Path: <linux-kernel-owner+w=401wt.eu-S965773AbXCVF4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773AbXCVF4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965774AbXCVF4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:56:34 -0400
Received: from 1wt.eu ([62.212.114.60]:1348 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965773AbXCVF4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:56:34 -0400
Date: Thu, 22 Mar 2007 06:53:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070322055306.GZ943@1wt.eu>
References: <20070320181442.1ae73295@lxorguk.ukuu.org.uk> <20070321151952.02b5612d.akpm@linux-foundation.org> <20070322001050.13588e5e@lxorguk.ukuu.org.uk> <20070321161341.0f87ed60.akpm@linux-foundation.org> <20070321232433.GX943@1wt.eu> <20070321234318.GE9092@redhat.com> <20070322041242.GA29741@1wt.eu> <20070322041751.GB17159@redhat.com> <20070322044540.GA32191@1wt.eu> <20070322050250.GC17159@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322050250.GC17159@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 01:02:50AM -0400, Dave Jones wrote:
> On Thu, Mar 22, 2007 at 05:45:40AM +0100, Willy Tarreau wrote:
>  > On Thu, Mar 22, 2007 at 12:17:51AM -0400, Dave Jones wrote:
>  > > On Thu, Mar 22, 2007 at 05:12:42AM +0100, Willy Tarreau wrote:
>  > >  > On Wed, Mar 21, 2007 at 07:43:18PM -0400, Dave Jones wrote:
>  > >  > > On Thu, Mar 22, 2007 at 12:24:33AM +0100, Willy Tarreau wrote:
>  > >  > >  
>  > >  > >  > Then a printk() on every open() should be enough. We've all been seeing
>  > >  > >  > "Warning: tcpdump uses obsolete AF_PACKET"... and it finally disappeared.
>  > >  > > 
>  > >  > > There's a difference.  We have the source for tcpdump.
>  > >  > 
>  > >  > But what's the problem with "warning: process XXX uses obsolete raw driver
>  > >  > and may not work anymore after 2007/XX/XX if not fixed" ?
>  > > 
>  > > The target audience isn't going to read it.
>  > 
>  > Yes they will if you write it with KERN_CRIT.
> 
> *no*.
> 
> Users will see it. The developers of the software those users are running won't.
> We're talking about apps here that we don't have the source to, and vendors
> want extortionate amount of money to change.

Dave, I think you don't get it. People are paying to run those apps. When
you pay 10s or 100s of K$ a year for support and you see such messages
appear in your logs, you ask the app vendor what will happen at the given
date. Those people are already afraid by end of support on products without
any warning message. I sincerely believe that they will insist even more
when the message tells them about the end of compatibility date.

Of course, the vendor will say "we've been informed that this is caused by
a change in distro XXX. Distro YYY does not have it, you may want to migrate".
But those responses rarely satisfy customers who have to revalidate everything
to change a distro.

At most, they will ask their distro vendor for continued support of the
feature (which there will be in the same minor release), and if vendors'
feedback show there is enough demand, then we will just have to delay the
removal.

Regards,
Willy

