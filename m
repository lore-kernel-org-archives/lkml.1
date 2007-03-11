Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXCKKdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXCKKdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 06:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXCKKdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 06:33:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXCKKdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 06:33:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [RFC][PATCH 0/3] swsusp: Stop using page flags
Date: Sun, 11 Mar 2007 11:17:26 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111117.27083.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches make swsusp use its own data structures for memory
management instead of special page flags.  Thus the page flags used so far by
swsusp (PG_nosave, PG_nosave_free) can be used for other purposes and I believe
there are some urgend needs of them. :-)

Last week I sent these patches to the linux-pm and linux-mm lists and there
were no negative comments.  Also I've been testing them on my x86_64 boxes for
a few days and apparently they don't break anything.  I think they can go into
-mm for testing.

Comments are welcome.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

