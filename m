Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbZLRSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbZLRSl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZLRSl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:41:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49764 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZLRSl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:41:57 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Joe Perches <joe@perches.com>,
       Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105 chars
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
	<20091218055712.GA4186@linux-sh.org>
	<alpine.LFD.2.00.0912180942480.3712@localhost.localdomain>
Date: Fri, 18 Dec 2009 19:41:50 +0100
In-Reply-To: <alpine.LFD.2.00.0912180942480.3712@localhost.localdomain> (Linus Torvalds's message of "Fri, 18 Dec 2009 09:43:49 -0800 (PST)")
Message-ID: <871visuntd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>
> I like this. Except I think the indent test should count spaces too some 
> way. Or do we already warn about excessive space that should be tabs?

checkpatch warns about those.

(it triggers for me all the time because those happen when you 
copy patch reject blocks from hand and remove the leading character
without removing the space afterwards)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
