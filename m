Return-Path: <linux-kernel-owner+w=401wt.eu-S933856AbXC0AXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbXC0AXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 20:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933851AbXC0AXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 20:23:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55481 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933855AbXC0AXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 20:23:40 -0400
Date: Tue, 27 Mar 2007 11:23:24 +1100
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, dgc@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
Message-ID: <20070327002324.GU32597093@melbourne.sgi.com>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu> <20070325153508.10922ebd.akpm@linux-foundation.org> <E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu> <20070326010124.b4513ce2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326010124.b4513ce2.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 01:01:24AM -0800, Andrew Morton wrote:
> On Mon, 26 Mar 2007 10:26:18 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> > Ditto for the case, when there are no more dirty pages destined for
> > this queue.
> > 
> > I understand, that this can fill up the memory with under writeback
> > pages, but only if the data sitting in all the device queues is
> > comparable to the total memory.  I don't know what the realistic
> > chance of that is but David Chinner convinced me, that it's not
> > something that happens in real life.  Quoting him from an earlier
> > mail:
> > 
> > | Right, and most ppl don't have enough devices in their system for
> > | this to be a problem. Even those of us that do have enough devices
> > | for this to potentially be a problem usually have enough RAM in
> > | the machine so that it is not a problem....
> > 
> 
> David is overoptimistic ;)

My excuse is that I have trouble thinking in units of memory smaller
than a GB. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
