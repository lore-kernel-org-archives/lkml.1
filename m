Return-Path: <linux-kernel-owner+w=401wt.eu-S1422665AbXD3A4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422665AbXD3A4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422675AbXD3A4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:56:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48586 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422665AbXD3A4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:56:53 -0400
Date: Sun, 29 Apr 2007 17:59:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070429175925.1c1d63b3.randy.dunlap@oracle.com>
In-Reply-To: <20070427221803.2a117c23.akpm@linux-foundation.org>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
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

On Fri, 27 Apr 2007 22:18:03 -0700 Andrew Morton wrote:

> On Fri, 27 Apr 2007 23:08:05 -0400 Dave Jones <davej@redhat.com> wrote:
> 
> > You can find the script at http://www.codemonkey.org.uk/projects/checkpatch/
> 
> hm.
> 
...

> box:/usr/src/25> ~/checkpatch.pl patches/git-powerpc.patch
> Checking patches/git-powerpc.patch:  signoffs = 427       
> kmalloc return shouldn't be cast.
> 10969:+ char *out = (char*)kmalloc(count + 1, GFP_KERNEL);
> 
> Use 'inline' instead of '__inline__'26644:+static __inline__ void atomic_scrub(void *va, u32 size)

Fixed missing \n.

...

> A good start, thanks.  The BUG_ON() thing might be unpopular, but I think it's
> for the best.  It should skip BUILD_BUG_ON though.

BUILD_BUG_ON is now skipped (in my script, not sent to DaveJ yet).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
