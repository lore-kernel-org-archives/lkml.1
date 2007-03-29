Return-Path: <linux-kernel-owner+w=401wt.eu-S1030354AbXC2QhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354AbXC2QhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030357AbXC2QhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:37:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12320 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030354AbXC2QhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:37:23 -0400
Date: Thu, 29 Mar 2007 09:38:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix dependency generation
Message-Id: <20070329093838.d5b2d88a.randy.dunlap@oracle.com>
In-Reply-To: <460C0020.76E4.0078.0@novell.com>
References: <460BA292.76E4.0078.0@novell.com>
	<20070329083947.d9ba87e0.randy.dunlap@oracle.com>
	<460C0020.76E4.0078.0@novell.com>
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

On Thu, 29 Mar 2007 17:06:24 +0100 Jan Beulich wrote:

> >>> Randy Dunlap <randy.dunlap@oracle.com> 29.03.07 17:39 >>>
> >> --- linux-2.6.21-rc5/scripts/basic/fixdep.c	2007-02-04 19:44:54.000000000 +0100
> >> +++ 2.6.21-rc5-fixdep-mod/scripts/basic/fixdep.c	2007-03-29 11:11:10.000000000 +0200
> >> @@ -29,8 +29,7 @@
> >>   * option which is mentioned in any of the listed prequisites.
> >>   *
> >>   * To be exact, split-include populates a tree in include/config/,
> >> - * e.g. include/config/his/driver.h, which contains the #define/#undef
> >> - * for the CONFIG_HIS_DRIVER option.
> >
> >I don't see why you deleted the line above.
> 
> Because it is no longer true. These files are empty as of 2.6.18.

We seem to be talking about different lines above.  Yes, the files
are empty, but they are named based on the CONFIG_symbol name, which
is what I was trying to get at.  So how about a comment like this:

 * To be exact, split-include populates a tree in include/config/,
 * e.g., include/config/sysctl/syscall.h,
 * for the CONFIG_SYSCTL_SYSCALL option, when that option
 * is enabled (=y or =m).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
