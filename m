Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZLRRyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZLRRyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZLRRyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:54:46 -0500
Received: from mail.perches.com ([173.55.12.10]:1288 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbZLRRyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:54:45 -0500
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105
 chars
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Valdis.Kletnieks@vt.edu,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com
In-Reply-To: <alpine.LFD.2.00.0912180942480.3712@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain>
	 <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	 <24653.1261110557@localhost> <1261113144.13734.317.camel@Joe-Laptop.home>
	 <20091218055712.GA4186@linux-sh.org>
	 <alpine.LFD.2.00.0912180942480.3712@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 09:54:44 -0800
Message-ID: <1261158884.24328.37.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 09:43 -0800, Linus Torvalds wrote:
> I like this. Except I think the indent test should count spaces too some 
> way. Or do we already warn about excessive space that should be tabs?

Andy's the checkpatch guy to verify this but:

There's a separate test for spaces that should be tabs.

If you had a 64 space indent and ran the silly script,
it'd complain about the spaces.

If you converted the spaces to tabs and ran the silly
script again with --strict, it'd complain about the
indent depth.

