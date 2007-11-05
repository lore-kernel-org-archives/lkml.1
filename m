Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbXKENEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbXKENEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 08:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXKENE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 08:04:29 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41945
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbXKENE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 08:04:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Date: Mon, 5 Nov 2007 14:03:38 +0100
User-Agent: KMail/1.9.6
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Michael Wu" <flamingice@sourmilk.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, "Michael Chan" <mchan@broadcom.com>,
       netdev@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>
References: <20071101191716.GA3201@pogo> <1194264016.27652.428.camel@twins> <84144f020711050423r7a1f0e55g36c8c5ad29bfc700@mail.gmail.com>
In-Reply-To: <84144f020711050423r7a1f0e55g36c8c5ad29bfc700@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711051403.39479.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2007 13:23:50 Pekka Enberg wrote:
> Hi Michael,
> 
> On Sat, 2007-11-03 at 21:06 +0100, Michael Buesch wrote:
> > Who is responsible for slab btw?
> > I mean, someone should be interested in getting this bug fixed. :)
> > When using slab I see random corruptions. I think related to rmmod, but
> > I'm not sure. I don't see this with slub.
> 
> Is CONFIG_DEBUG_SLAB enabled? Usually these kind of random corruptions
> are caused by someone passing a bad pointer to kfree() or
> kmem_cache_free().

Yeah.

What I also saw was random "one-bit-errors" once and then on rmmod of modules.
I have absolutely no idea how they were caused, though (I read the freeing
codes of the stuff hundreds of times). I don't have any of the oops messages
anymore.
But I do _not_ see this behaviour with slub anymore.

-- 
Greetings Michael.
