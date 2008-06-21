Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbYFUTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbYFUTR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYFUTRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:17:47 -0400
Received: from emerald.lightlink.com ([64.57.176.19]:7925 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYFUTRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:17:45 -0400
Date: Sat, 21 Jun 2008 14:55:16 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates vs. v2.6.26-rc6
Message-ID: <20080621185516.GA29869@mars.solarsys.private>
References: <20080619123304.GF7306@mars.solarsys.private> <alpine.LFD.1.10.0806201231590.3167@woody.linux-foundation.org> <20080620203023.GJ7306@mars.solarsys.private>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20080620203023.GJ7306@mars.solarsys.private>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

* Mark M. Hoffman <mhoffman@lightlink.com> [2008-06-20 16:30:23 -0400]:
> Hi Linus:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> [2008-06-20 12:32:27 -0700]:
> > 
> > 
> > On Thu, 19 Jun 2008, Mark M. Hoffman wrote:
> > > 
> > > Please pull from:
> > > 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release
> > 
> > I'm just getting:
> > 
> > 	fatal: Unable to look up lm-sensors.org (port 9418) (Temporary failure in name resolution)
> > 
> > do you have DNS problems?
> 
> Sorry, yes.  I've already sent email to the site admin some hours ago.  If it
> doesn't work itself out quickly (within next 24 hours) I'll just send you the
> patches directly.

Still down... so I've attached a git bundle (to preserve history).

I did this in my public repo:

	$ git bundle create ~/hwmon-release-bundle release ^v2.6.26-rc6

(yes, that tag is the base for my release branch)

As a smoke test, I did the following in a fresh-cloned repo locally:

	$ git bundle verify ~/hwmon-release-bundle

	$ git pull ~/hwmon-release-bundle refs/heads/release

Looks like it DTRT, so here you go...

Thanks & regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com


--G4iJoqBmSsgzjUCe
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=hwmon-release-bundle
Content-Transfer-Encoding: base64

IyB2MiBnaXQgYnVuZGxlCi01ZGQzNDU3MmFkOWEzYmU0MzA2MzJkZDQyZTRhZjJlYTM3MGIz
OTdiIExpbnV4IDIuNi4yNi1yYzYKYmNjY2MzYTI4ZTljYmI0NDU0OWNkZTMyNjg1MmMyNjIw
M2E1M2E1NiByZWZzL2hlYWRzL3JlbGVhc2UKClBBQ0sAAAACAAAAIZYkeJyNUcmO1DAQvfsr
6ggSiZLO3mqNGjQHhOgT/EA5LidWO3bkJTP8PdUwJ+DArey31PNzCkSArWpQD6dKTkPfNHUz
41BXLVV9NSt9IhzbmuFe7BjIJZANEkrGpKo0dU0zYYPdVI+ym4ikrttxlrOqBea0+gDPeBgF
n4J/cWQtXNTjXMjrjrPki9JReoL6VE1jP3RdD0U1VJWY/baZlCjADcMdbiV89lpv6OCyrb+n
qzXLmqxx95LZD4+6GTloc2KPlj3E+rJ5d4Z3dhu69xDJRc4TCJVxC8i8aPMqxNfb0P0bO4Oj
gxNEPAgoBCbEhClHwAgHWqPEm87ntOdUAnxfTYTZZ6tAEphtD/4g9YENE2ACSxgTJCaJPbC3
S8ymkNA4CFkRaDQ2B4LNK4qlEN/M4kgV/OBC/jj/3aV8G685Uohl9DnMpH1Y6Fev4uN8Z/lD
+oW4u2eyB/8iXO4rx+cCXX4tdChZ8PTnrv/tXfwEksjDXZM1eJyNUs1u2zAMvuspeGyxxbMl
O3aLYmiLAWsGFDt0L0BbdKTFlgJJbpY9/eg4XTDs0otA0/x++IEpEIGWN1Wty0apWuVV1+ZK
dapSndSkSq10U6zVTSlR7DGQSyCrpqw6Kddl3aOWmDeV7Pp128u61k1JDda4bksUOCXjAzyh
i6AJvnri9+5ndshCpmk7f94bEzM3fIZCFkVVFU1ZwIdc5rno/DjalCjAM4YdPGfw5Pt+RAd3
o1mq+8FuTRqs22U8feJQTS3XSsIqL5lDmMPo3S1cYWvTtJ3CpK5h2mtMvHWwr0yuKVGXrHdC
bBIYjNASOQi09yGRhmQw8UNwoXiD9miHCMnD4FED9rNXhMfN9xexaGTww9gIe0ydgd7+Ip6e
G+2RIT6Ss2574v5rAoKfknUE0S/KNomDHQY4eM5gkZgBs8jbIsl7FvLAEezJxbnV+2XM+QOw
07OcuMhwiqi1nWscoDPU7YCNcY9X5v8z+MvzBh4xspjHoJnHaaaNKZxcezHijn1OgeBAjBmO
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

--G4iJoqBmSsgzjUCe--
