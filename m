Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZBUElu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZBUElu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 23:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZBUEll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 23:41:41 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:57423 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZBUEll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 23:41:41 -0500
Date: Fri, 20 Feb 2009 23:41:21 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Arve__Hj=F8nnev=E5g?= <arve@android.com>,
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
Subject: Re: [PATCH 0/9] PM: Fixes related to suspend and hibernation for 2.6.29
In-reply-to: <200902140157.40869.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.0902202337040.19156@localhost.localdomain>
References: <200902140157.40869.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 14 Feb 2009, Rafael J. Wysocki wrote:

> Hi Len,
> 
> The following are fixes related to suspend and hibernation I have collected
> over the last couple of weeks.  Some of them are in -mm.  I think they all are
> 2.6.29 material.
> 
> 1/9 and 2/9 fix hibernation regression caused by the async boot changes,
> I hope Greg will not object if they go through your tree.
> 
> 3/9 fixes a long-standing hibernation issue that cause the resume partition
> to become unuseable after two consecutive failing attempts to hibernate.
> 
> 4/9 fixes build of kprobes.c with CONFIG_PM unset.

looks like this one added power/ twice --
and looks like akpm sent a fixed version of this to linus already?

> 5/9 and 6/9 clean up memory freeing code used during hibernation.
> 
> 7/9 fixes a bug related to the use of PM notifiers during hibernation with
> the help of the user land interface.
> 
> 8/9 and 9/9 fix the handling of consoles during suspend/hibernation.
> 
> Please add these patches to the suspend branch and push to Linus for 2.6.29.

All except #4 are now on the suspend branch.
thanks,
--
Len Brown, Intel Open Source Technology Center
