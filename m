Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbXCKKwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbXCKKwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 06:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXCKKwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 06:52:18 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:47488 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbXCKKwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 06:52:18 -0400
Subject: Re: [RFC][PATCH 0/3] swsusp: Stop using page flags
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <200703111117.27083.rjw@sisk.pl>
References: <200703111117.27083.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 11:52:05 +0100
Message-Id: <1173610325.5182.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 11:17 +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> The following three patches make swsusp use its own data structures for memory
> management instead of special page flags.  Thus the page flags used so far by
> swsusp (PG_nosave, PG_nosave_free) can be used for other purposes and I believe
> there are some urgend needs of them. :-)
> 
> Last week I sent these patches to the linux-pm and linux-mm lists and there
> were no negative comments.  Also I've been testing them on my x86_64 boxes for
> a few days and apparently they don't break anything.  I think they can go into
> -mm for testing.
> 
> Comments are welcome.

These patches have my blessing, they look good to me, but I'm not much
involved with the swsusp code, so I won't ACK them.

Again, thanks a bunch for freeing up 2 page flags :-)

Peter

