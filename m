Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZBEIaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZBEIaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZBEIaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:30:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52407 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZBEIaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:30:04 -0500
Date: Thu, 5 Feb 2009 09:46:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090205084627.GF14832@one.firstfloor.org>
References: <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu> <20090110220135.GF20611@logfs.org> <20090110142330.295a8847.akpm@linux-foundation.org> <1231631840.13420.24.camel@twins> <1233793066.7390.34.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233793066.7390.34.camel@johannes.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my use case, tracking the wifi APs around you, you have to scale from
> a single one to >1k (yes, it's happening!), and lookups better be fast
> because you might be doing them a lot (dozens of times per second).

dozens of times per second is actually not a lot on any reasonable system.
anything that's not totally screwed up (like the rbtrees) should be fine.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
