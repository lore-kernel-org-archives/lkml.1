Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbXDZEZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbXDZEZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXDZEZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:25:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbXDZEZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:25:40 -0400
Date: Thu, 26 Apr 2007 00:24:50 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, arnd@arndb.de, maxextreme@gmail.com,
       gregkh@suse.de
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Message-ID: <20070426042450.GB11278@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	mb@bu3sch.de, linville@tuxdriver.com, arnd@arndb.de,
	maxextreme@gmail.com, gregkh@suse.de
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org> <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425200207.77a2721a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 08:02:07PM -0700, Andrew Morton wrote:
 > On Wed, 25 Apr 2007 19:38:23 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
 > > > In fact, I should probably munge it together with a similar thing
 > > > I wrote at http://www.codemonkey.org.uk/projects/findbugs/
 > > > (Warning: scary regexps)
 > > I'll be glad to help maintain such animals if wanted.
 > 
 > wanted ;)
 > 
 > At least, it would be interesting to investigate the usefulness.  I suspect
 > it will prove to be very useful for the little things.

Yeah, the original script tried to do things like spinlock balancing checks,
(badly). This was long before had sparse, and it was partly a "lets learn some perl"
experience for myself. I'll toss that idea out now that we have better tools
for that, and keep it to simple checks.

 > Heck, someone could subscribe a robot to all the mailing lists which sends
 > nastygrams straight back at people who submit broken patches.  We already
 > need that for tab-replaced and word-wrapped patches.  (ok, we have it -
 > it's called akpm, but being robotic wearies one)

Ok, I've got a few different flavours of that script. I'll roll them
all into one tomorrow and throw out some of the noisy silly ones
(I don't think warning about strcpy->strncpy is really worthwhile for eg).

Additional regexps gratefully recieved.

	Dave

-- 
http://www.codemonkey.org.uk
