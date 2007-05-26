Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXEZPvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXEZPvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXEZPu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:50:57 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38113
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXEZPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:50:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 17:50:48 +0200
User-Agent: KMail/1.9.6
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705260700.28777.mb@bu3sch.de> <200705261240.55153.uwe.bugla@gmx.de>
In-Reply-To: <200705261240.55153.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705261750.48816.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I am going to ignore Uwe from now on. It's simply impossible
to debug the problem the way he is responding.
Well, I'm not the first person in the Linux community adding
him to the killfile, ... .
I ask to try wireless-dev, as the driver works perfectly fine
for me there, but he refuses to try it, too. So I'm stuck.
I already tried your -mm kernel, but it crashes on my machine
for other reasons. (Yeah, I should look into them, too :P )

Andrew, is it possible that the breakage was introduced in the
merge process somehow? Didn't the patch apply cleanly? Are there
other changes to b44 I should know about in your tree?

If it is really impossible to debug this problem, I'd like to
suggest you to drop the b44-ssb port completely.
I'm not going to destroy my nerves any further with guys like
Uwe, so I'll include the b44-ssb port in the OpenWRT tree
and be done with it.
Although I would be very sad about it, as my longterm goal was
to make a vanilla kernel run on the OpenWRT devices... .

But maybe we can get another tester for -mm with similiar problems,
who is not bullshitting the whole time and is also going to
test wireless-dev to make sure it's not a merge bug.


-----------

And Uwe: Remember, I am not payed for this. I do _all_ this
in my free time.
So sentences like: "So, the ball has been in your court
for two days now, and you simply keep on hesitating
to take action now."
are _completely_ displaced in this discussion.

-- 
Greetings Michael.
