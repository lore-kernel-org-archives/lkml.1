Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbZLRF5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbZLRF5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZLRF5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:57:20 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38722 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZLRF5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:57:20 -0500
Date: Fri, 18 Dec 2009 14:57:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joe Perches <joe@perches.com>
Cc: Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105 chars
Message-ID: <20091218055712.GA4186@linux-sh.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain> <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com> <24653.1261110557@localhost> <1261113144.13734.317.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261113144.13734.317.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:12:24PM -0800, Joe Perches wrote:
> On Thu, 2009-12-17 at 23:29 -0500, Valdis.Kletnieks@vt.edu wrote:
> > Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> > continuation line, it's probably in its rights to whinge. 
> > 	grep -r -P '^\t{7:}(?!(.*,$|.*\);$))' . | more
> > produces a whole lot of "this can't end well" output.
> 
> I think this is a good test to add to checkpatch.
> 
> Add 105 character long line WARN test
> Add 80 character long line STRICT test
> Add 6+ leading indent tabs test, consider restructuring
> 
This looks like a reasonable compromise.
