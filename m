Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXCUXYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXCUXYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbXCUXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:24:53 -0400
Received: from 1wt.eu ([62.212.114.60]:1309 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbXCUXYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:24:52 -0400
Date: Thu, 22 Mar 2007 00:24:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070321232433.GX943@1wt.eu>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6> <p73y7lu5yt6.fsf@bingen.suse.de> <20070320165736.GA19781@redhat.com> <20070320181442.1ae73295@lxorguk.ukuu.org.uk> <20070321151952.02b5612d.akpm@linux-foundation.org> <20070322001050.13588e5e@lxorguk.ukuu.org.uk> <20070321161341.0f87ed60.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321161341.0f87ed60.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 04:13:41PM -0700, Andrew Morton wrote:
> On Thu, 22 Mar 2007 00:10:50 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > > This is a user visible API it is therefore not elligable for removal
> > > > anyway
> > > 
> > > mutter.
> > > 
> > > We've given people years of notice and _some_ applications have converted
> > > over to open("/dev/sda1", O_DIRECT), as they should.
> > 
> > Linus said we don't break old applications by removing APIs. People
> > believe him. 
> > 
> 
> That's just dogma, and not credible dogma at that.  We regularly remove
> features and we have processes for this.
> 
> There is no reason why we cannot, with sufficient effort, remove this
> driver at some time in the future.

Then a printk() on every open() should be enough. We've all been seeing
"Warning: tcpdump uses obsolete AF_PACKET"... and it finally disappeared.
It's a slow but necessary process IMHO. I agree with Alan that it's not
nice for the users to have sudden application errors without enough earlier
notification (not everybody reads sources for removal notifications).

Regards,
Willy

