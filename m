Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYDFVK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYDFVK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 17:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYDFVKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 17:10:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50582 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbYDFVKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 17:10:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc8-git2: Reported regressions from 2.6.24
Date: Sun, 6 Apr 2008 23:10:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <alpine.LFD.1.00.0804051143270.11277@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804051143270.11277@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062310.20762.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of April 2008, Linus Torvalds wrote:
> 
> On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10349
> > Subject		: regression: am-utils stopped working in 2.6.25-rc*
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2008-03-28 15:20 (7 days old)
> > References	: http://lkml.org/lkml/2008/3/28/174
> 
> This seems to be a bug in am-utils:
> 
> 	https://bugzilla.am-utils.org/show_bug.cgi?id=612
> 
> and while we try very hard to not break existing binaries that assume some 
> old broken kernel behaviour, things like system setup code that is 
> outright buggy is kind of exempt from that rule. So I think in this case 
> it really is a user-level issue.

OK, closed.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10346
> > Subject		: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
> > Submitter	: Georgi Chorbadzhiyski <gf@unixsol.org>
> > Date		: 2008-03-27 17:29 (8 days old)
> > References	: http://lkml.org/lkml/2008/3/27/246
> 
> I wouldn't call this a regression. It's a hard-to-trigger warning that is 
> being debugged. 

Dropped from the list.

Thanks,
Rafael
