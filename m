Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbYDQJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbYDQJFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYDQJFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:05:45 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41417 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYDQJFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:05:44 -0400
Date: Thu, 17 Apr 2008 11:04:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Benc <jbenc@suse.cz>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH-mm 1/3] mac80211: tkip.c use get/put_unaligned helpers
In-Reply-To: <20080417105859.45092413@griffin.suse.cz>
Message-ID: <Pine.LNX.4.64.0804171102370.19002@twin.jikos.cz>
References: <1208370570.11920.107.camel@brick> <20080417105859.45092413@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Jiri Benc wrote:

> > This depends on the introduction of the new unaligned helpers, and applies
> > on top of the cleanup patches already in -mm.
> Please send all mac80211 patches to the linux-wireless mailing list and
> CC Johannes Berg. (It's a good idea to resend all of the mac80211
> patches you sent.)

This patchset is quite special though, as it touches a lot of subsystems 
and depends on code not yet present in mainline ... quoting Andrew's reply 
to me:

==
> I guess you are going to push this stuff through -mm altogether, right? 
> I can hardly take this into my tree right now, as the helpers are not in 
> Linus' tree yet.

yeah, sorry, that's been confusing a few people.

Strictly I'd merge the core infrastructure and then send the dependent 
patches into the relevant maintainers.  But that can mean than we 
needlessly miss the merge window, so it's most parctical to send along an 
acked-by and I'll merge the dependent patch directly with the appropriate 
ordering.
==

-- 
Jiri Kosina
