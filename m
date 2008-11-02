Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYKBV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYKBV6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYKBV6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:58:22 -0500
Received: from ozlabs.org ([203.10.76.45]:37925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbYKBV6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:58:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18702.8817.634094.493649@cargo.ozlabs.ibm.com>
Date: Mon, 3 Nov 2008 08:58:09 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [Bug #11907] NVRAM being corrupted on ppc64 preventing boot
In-Reply-To: <4xS1r6m15_B.A.2F.3ueDJB@chimera>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
	<4xS1r6m15_B.A.2F.3ueDJB@chimera>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).

The commit that introduced the problem went into Linus' tree after
2.6.27, so it's not a regression from 2.6.26.  In other words, 2.6.27
doesn't have the problem.  It's a firmware bug in some old firmware
versions that got triggered by the kernel change, not a kernel bug per
se.

The commit has been reverted in Linus' tree now, so there isn't a
regression from 2.6.27 any more.

Paul.
