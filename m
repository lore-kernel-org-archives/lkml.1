Return-Path: <linux-kernel-owner+w=401wt.eu-S1161537AbXBHIDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161537AbXBHIDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161538AbXBHIDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:03:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:50035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161537AbXBHIDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:03:50 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG][PATCH] fix mempolcy's check on a system with memory-less-node take2
Date: Thu, 8 Feb 2007 09:03:46 +0100
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       GOTO <y-goto@jp.fujitsu.com>
References: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com> <200702080849.42167.ak@suse.de> <20070208000001.9e303a1a.akpm@linux-foundation.org>
In-Reply-To: <20070208000001.9e303a1a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702080903.46242.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 February 2007 09:00, Andrew Morton wrote:
> On Thu, 8 Feb 2007 08:49:41 +0100 Andi Kleen <ak@suse.de> wrote:
> 
> > 
> > > This panic(hang) was found by a numa test-set on a system with 3 nodes, where
> > > node(2) was memory-less-node.
> > 
> > I still think it's the wrong fix -- just get rid of the memory less node.
> 
> "Let's break it even more"?

I still don't get what you believe what would be broken then.

> > I expect you'll likely run into more problems with that setup anyways.
> 
> What happens if he doesn't run into more problems?

Then he's lucky. I ran into problems at least when I still had the empty
nodes some time ago on x86-64.  Christoph said SN2 is doing the same.

iirc slab blew up at least, but that  might be fixed by now. But it's a little risky 
because there is more code now that is node aware.

-Andi
