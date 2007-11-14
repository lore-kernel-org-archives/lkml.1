Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbXKNWzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbXKNWzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbXKNWzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:55:33 -0500
Received: from waste.org ([66.93.16.53]:53094 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbXKNWzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:55:33 -0500
Date: Wed, 14 Nov 2007 16:53:36 -0600
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071114225335.GV19691@waste.org>
References: <20071114173611.GR19691@waste.org> <20071114183952.GS19691@waste.org> <20071114190501.GA5768@elte.hu> <20071114.143938.23516450.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114.143938.23516450.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 02:39:38PM -0800, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 14 Nov 2007 20:05:01 +0100
> 
> > the bug went away - and the only thing i did was a networking config 
> > tweak. So maybe something in networking corrupts memory?
> 
> This wouldn't surprise me at all.
> 
> I think we can make some headway on this bug, the next time
> you trigger it, if the list debugging was a little less terse.
> 
> For example, a backtrace and perhaps even feeding the bad list
> pointers in question to the SLAB/SLUB debug helpers that can
> identify a kmem cache from a given pointer would help.

He hit the bug using SLOB and there are no kmem (or any other) caches
in SLOB.

-- 
Mathematics is the supreme nostalgia of our time.
