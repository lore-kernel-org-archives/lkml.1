Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbZBTHeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbZBTHeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZBTHdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:33:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:45711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZBTHdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:33:46 -0500
Message-ID: <499E5CC1.8030800@kernel.org>
Date: Fri, 20 Feb 2009 16:33:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <200902192121.55157.rusty@rustcorp.com.au> <20090219110631.GJ2354@elte.hu> <200902192244.15055.rusty@rustcorp.com.au> <499E1E99.6030508@kernel.org> <499E4142.8020907@kernel.org>
In-Reply-To: <499E4142.8020907@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 07:33:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Ingo, as you haven't pulled already.  I'm incorporating changes from
> the comments posted till now and rebasing the tree.  Please stand by a
> bit.

Alright, the updated tree is at

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git tj-percpu

The commit ID is 11124411aa95827404d6bfdfc14c908e1b54513c.

Changes from the last tree are...

* Lai's patch to use percpu data for irq stacks is now the first one.

* The bogus modalloc fix patch dropped.

* Scary comments to map/unmap_kernel_range_noflush() added as per
  Nick's suggestion.

* implement-new-dynamic-percpu-allocator patch updated as per Andrew's
  suggestions.

I think I'll just stack future changes on top of this tree from now
on, so please feel free to pull from it.

Thanks.

-- 
tejun
