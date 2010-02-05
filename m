Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab0BERjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:39:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100Ab0BERjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:39:21 -0500
Date: Fri, 5 Feb 2010 15:34:23 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, balbir@linux.vnet.ibm.com,
       jdike@addtoit.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
Message-ID: <20100205173422.GA14706@amt.cnet>
References: <20100203161103.11e2b572@annuminas.surriel.com>
 <20100204041212.GI19641@balbir.in.ibm.com>
 <4B6ACE5B.9080601@redhat.com>
 <20100204174715.GL5959@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204174715.GL5959@random.random>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 06:47:15PM +0100, Andrea Arcangeli wrote:
> On Thu, Feb 04, 2010 at 08:40:43AM -0500, Rik van Riel wrote:
> > I suspect it won't be very many. I have been monitoring
> > /proc/meminfo on my system while testing this patch, and
> > it is quite typical that the size of the inactive anon
> > list does not change for minutes at a time.
> > 
> > In other words, no pages are moved onto or off of the
> > inactive anon list for several minutes. That corresponds
> > to a very small number of minor faults introduced by my
> > patch.
> 
> When there's light VM pressure, ideally there should be zero overhead
> caused by the patch. When there is VM pressure this will avoid some
> unnecessary I/O which should outweight the minor faults. It should be
> a good default behavior.

Agree.

But perhaps a module parameter to turn accessed bit emulation off might
be handy in the future?

