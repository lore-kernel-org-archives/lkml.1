Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbZH1IX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbZH1IX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZH1IX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:23:56 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44061 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZH1IXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:23:55 -0400
Message-ID: <4A97940A.7020703@s5r6.in-berlin.de>
Date: Fri, 28 Aug 2009 10:23:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Chris Wright <chrisw@sous-sol.org>, stable-review@kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       =?UTF-8?B?Q2hyaXM=?= =?UTF-8?B?dGlhbiBTdMO2dmVrZW4=?= 
	<launchpad.net@excogitation.de>
Subject: Re: Would it help to encourage users to read/test stable-review 
 patches
References: <43e72e890908271122l6b08aaa5lc66de78301c7c88d@mail.gmail.com> 	<20090827182952.GC10360@sequoia.sous-sol.org> <43e72e890908271209mdbaaf03l820aade2266eb54c@mail.gmail.com>
In-Reply-To: <43e72e890908271209mdbaaf03l820aade2266eb54c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
>> More review never hurts, but do you think there's a specific lack or
>> problem?
> 
> Not really, I was thinking about the fellow Ubunteros users who tend
> to not have a clue but sometimes enough good will to want to help. If
> the average user understood better the upstream process then perhaps
> it would become clearer to them the importance of stable patches and
> stable-review.

Shouldn't these people rather get started with "the other stable
kernel", called 2.6.x-rcZ?  And the next level would be to either test
-next or follow the master branch of a subsystem development tree of
their interest.

I think it could be more effective overall to activate more people who
watch for regressions in the mainline, send qualified and early
regression reports, and test candidate fixes.  A side effect of better
-rc kernels will be a shallower 2.6.x.y branch queue.

Patches which are submitted for stable-review should already have been
tested as part of the upstream kernel on affected and unaffected
systems.  As Chris wrote, patches which obviously need further field
testing when backported to -stable are per definition too risky for
-stable in the first place.  -stable submission should be low-risk
cherry-picking.

> Bringing users closer to stable-review to me indicates
> more users would understand the stable process and therefore would
> stop bitching to me when a 'non-cirtical' fix never made it into their
> ancient stable. Cc'ing one of those.

Ah, you have especially /these/ people in mind.  Well, set up a clever
procmail filter which autoresponds with a pointer to
Documentation/stable_kernel_rules.txt... :-)
-- 
Stefan Richter
-=====-==--= =--- ===--
http://arcgraph.de/sr/
