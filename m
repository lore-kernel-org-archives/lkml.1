Return-Path: <linux-kernel-owner+w=401wt.eu-S1763806AbZBNBUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763806AbZBNBUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762913AbZBNBIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:08:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762908AbZBNBIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:08:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/9] PM: Fixes related to suspend and hibernation for 2.6.29
Date: Sat, 14 Feb 2009 01:57:39 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140157.40869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The following are fixes related to suspend and hibernation I have collected
over the last couple of weeks.  Some of them are in -mm.  I think they all are
2.6.29 material.

1/9 and 2/9 fix hibernation regression caused by the async boot changes,
I hope Greg will not object if they go through your tree.

3/9 fixes a long-standing hibernation issue that cause the resume partition
to become unuseable after two consecutive failing attempts to hibernate.

4/9 fixes build of kprobes.c with CONFIG_PM unset.

5/9 and 6/9 clean up memory freeing code used during hibernation.

7/9 fixes a bug related to the use of PM notifiers during hibernation with
the help of the user land interface.

8/9 and 9/9 fix the handling of consoles during suspend/hibernation.

Please add these patches to the suspend branch and push to Linus for 2.6.29.

Thanks,
Rafael


-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan

