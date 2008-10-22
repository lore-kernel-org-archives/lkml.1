Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYJVOfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYJVOfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYJVOe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:34:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52073 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752578AbYJVOe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:34:56 -0400
Date: Wed, 22 Oct 2008 09:34:53 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] x86: Add UV watchlist bios call
Message-ID: <20081022143452.GA201004@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20081021200046.GC32545@sgi.com> <20081022062043.GC651@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022062043.GC651@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 08:20:43AM +0200, Ingo Molnar wrote:
> 
> * Russ Anderson <rja@sgi.com> wrote:
> 
> > Add UV bios calls to allocate and free watchlists.
> 
> hm, what is a watchlist?

It is a hardware feature in the SGI UV hardware, used as part
of the GRU message queue support.

It is used by drivers/misc/sgi-xp/xpc_uv.c.  Dean Nelson submitted
a patch yesterday that uses the watchlist bios call.

http://marc.info/?l=linux-kernel&m=122462426019304&w=2

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
