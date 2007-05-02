Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbXEBMOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbXEBMOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbXEBMOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:14:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58608 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbXEBMOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:14:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 2 May 2007 14:13:39 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [git pull] New firewire stack
To: Christoph Hellwig <hch@infradead.org>
cc: Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
In-Reply-To: <20070502090007.GA28174@infradead.org>
Message-ID: <tkrat.087ee29add656926@s5r6.in-berlin.de>
References: <4637A29F.6070302@redhat.com>
 <20070502090007.GA28174@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 01, 2007 at 04:27:11PM -0400, Kristian H??gsberg wrote:
>> Hi Linus,
>> 
>> As you may know, we've been working on a new FireWire stack over on
>> linux1394-devel.  The main driver behind this work is to get a small,
>> maintainable and supportable FireWire stack, with an acceptable
>> backwards compatibility story.
> 
> Please send out patches for review first.
> 

Yes, it's been a while since the last submission for review [1], and
most of the changes went over linux1394-devel only.  And to put it
mildly, there aren't a lot of capable reviewers watching that list.

Changes since last submission, AFAIR:
  - completion of the DMA engine
  - completion of the userspace ABI
  - extensions to exported sysfs attributes
  - some other feature additions like bus manager capability
  - lots of bug fixes
  - some style fixes

I'll folllow up with "git diff v2.6.21-rc3..juju" ripped apart,
reordered, and refreshed against 2.6.21:

[PATCH 1/6] firewire: handling of cards, buses, nodes
[PATCH 2/6] firewire: isochronous and asynchronous I/O
[PATCH 3/6] firewire: char device interface
[PATCH 4/6] firewire: OHCI-1394 lowlevel driver
[PATCH 5/6] firewire: SBP-2 highlevel driver
[PATCH 6/6] firewire: add it all to kbuild

(If this division seems odd, don't blame Kristian, blame me. :-)
I'm looking forward to comments.


   [1]	http://lkml.org/lkml/2006/12/19/306
	http://lkml.org/lkml/2006/12/19/307
	http://lkml.org/lkml/2006/12/19/309
	http://lkml.org/lkml/2006/12/19/310
	http://lkml.org/lkml/2006/12/19/308
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/

