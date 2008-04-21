Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbYDUTuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbYDUTuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYDUTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:49:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:37698 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759418AbYDUTt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:49:58 -0400
Message-ID: <480CEFBC.6050808@windriver.com>
Date: Mon, 21 Apr 2008 14:49:16 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kgdb: trivial sparse fixes in kgdb test-suite
References: <1208543475.17196.44.camel@brick>
In-Reply-To: <1208543475.17196.44.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 19:49:04.0729 (UTC) FILETIME=[C116B490:01C8A3E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Shadowed variable and integer as NULL pointer fixes:
> drivers/misc/kgdbts.c:877:6: warning: symbol 'sys_open_test' shadows
an earlier one
> drivers/misc/kgdbts.c:537:27: originally declared here
> drivers/misc/kgdbts.c:378:22: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:386:22: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:468:30: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:472:15: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:502:30: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:506:30: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:509:30: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:523:20: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:527:20: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:530:15: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:541:21: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:545:21: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:548:15: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:559:30: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:563:15: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:573:16: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:574:19: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:578:15: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:588:16: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:589:19: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:593:15: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:602:16: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:604:15: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:925:3: warning: Using plain integer as NULL pointer
> drivers/misc/kgdbts.c:938:3: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

This patch looked fine Harvey, I queued it for the next pull request at:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_linus

I made one minor change to 5 different code comments so as to make the
checkpatch.pl's 80 character check happy.

Thanks,
Jason.

