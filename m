Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYDES6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYDES6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 14:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYDES6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 14:58:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbYDES6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 14:58:15 -0400
Date: Sat, 5 Apr 2008 11:57:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc8-git2: Reported regressions from 2.6.24
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Message-ID: <alpine.LFD.1.00.0804051143270.11277@woody.linux-foundation.org>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10349
> Subject		: regression: am-utils stopped working in 2.6.25-rc*
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2008-03-28 15:20 (7 days old)
> References	: http://lkml.org/lkml/2008/3/28/174

This seems to be a bug in am-utils:

	https://bugzilla.am-utils.org/show_bug.cgi?id=612

and while we try very hard to not break existing binaries that assume some 
old broken kernel behaviour, things like system setup code that is 
outright buggy is kind of exempt from that rule. So I think in this case 
it really is a user-level issue.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10346
> Subject		: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
> Submitter	: Georgi Chorbadzhiyski <gf@unixsol.org>
> Date		: 2008-03-27 17:29 (8 days old)
> References	: http://lkml.org/lkml/2008/3/27/246

I wouldn't call this a regression. It's a hard-to-trigger warning that is 
being debugged. 

			Linus
