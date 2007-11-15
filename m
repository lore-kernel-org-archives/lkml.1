Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbXKOAKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbXKOAKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbXKOAKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:10:40 -0500
Received: from waste.org ([66.93.16.53]:35690 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbXKOAKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:10:39 -0500
Date: Wed, 14 Nov 2007 18:09:17 -0600
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071115000917.GX19691@waste.org>
References: <20071114225335.GV19691@waste.org> <20071114.151013.05582536.davem@davemloft.net> <20071114233713.GW19691@waste.org> <20071114.154143.112110604.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114.154143.112110604.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 03:41:43PM -0800, David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Wed, 14 Nov 2007 17:37:13 -0600
> 
> > No, the usual strategy for debugging problems -outside- SLOB is to
> > switch to another allocator with more extensive debugging facilities.
> 
> Ok, so the thing we still can do is do a dump_stack() at the
> list debugging assertion trigger points.

It's also pretty easy to add some debugging code to make SLOB walk all
its lists at alloc/free time.

-- 
Mathematics is the supreme nostalgia of our time.
