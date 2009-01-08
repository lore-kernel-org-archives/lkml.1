Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZAHQYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZAHQYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZAHQYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:24:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34844
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbZAHQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:24:12 -0500
Date: Thu, 08 Jan 2009 08:24:13 -0800 (PST)
Message-Id: <20090108.082413.156881254.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, jack@suse.cz,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@suse.de
Subject: Re: Increase dirty_ratio and dirty_background_ratio?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090108030245.e7c8ceaf.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0901070833430.3057@localhost.localdomain>
	<20090107.125133.214628094.davem@davemloft.net>
	<20090108030245.e7c8ceaf.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 8 Jan 2009 03:02:45 -0800

> The kernel can't get this right - it doesn't know the usage
> patterns/workloads, etc.

I don't agree with that.

The kernel is watching and gets to see every operation that happens
both to memory and to the disk, so of course it can see what
the "patterns" and the "workload" are.

It also can see how fast or slow the disk technology is.  And I think
that is one of the largest determinants to what these values should
be set to.

So, in fact, the kernel is the place that has all of the information
necessary to try and adjust these settings dynamically.

Userland can only approximate a good setting, at best, because it has
so many fewer pieces of information to work with.
