Return-Path: <linux-kernel-owner+w=401wt.eu-S1423365AbXDYSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423365AbXDYSU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423372AbXDYSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:20:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37806 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423363AbXDYSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:20:24 -0400
Date: Wed, 25 Apr 2007 11:21:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, mb@bu3sch.de, linville@tuxdriver.com,
       arnd@arndb.de, maxextreme@gmail.com, gregkh@suse.de
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Message-Id: <20070425112133.4ae86399.randy.dunlap@oracle.com>
In-Reply-To: <20070423104534.51bac974.akpm@linux-foundation.org>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 10:45:34 -0700 Andrew Morton wrote:

> On Mon, 23 Apr 2007 16:11:23 +0200
> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > Greetings,
> > I've added the results of the review to the Kconfig cleanup patches
> > for s390. Patch #2 has been split, one half has all the HAS_IOMEM
> > depends lines the other the remaining !S390 depends lines.
> > 
> > Andrew: I plan to add patches 1-5 to the for-andrew branch of the
> > git390 repository if that is fine with you. The only thing that will
> > be missing in the tree is the patch that disables wireless for s390.
> > The code does compile but without hardware it is mute to have the
> > config options. I'll wait until the git-wireless.patch is upstream.
> > Patches 7-9 depend on patches found in -mm.
> > 
> 
> umm, OK.  If it's Ok I think I'll duck it for now: -mm is full.
> 
> Over-full, really: I've been working basically continuously since Friday
> getting the current dungpile to compile and boot, and it's still miles away
> from that.

and I continue to be concerned about the amount of patch reviews
compared to new patch material overall (not just s390).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
