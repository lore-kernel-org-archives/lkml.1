Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZA3Iut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZA3Iut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZA3Iul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:50:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:54925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZA3Iuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:50:40 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1233294584.28741.2.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 09:50:33 +0100
Message-Id: <1233305433.4495.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 00:49 -0500, Nathanael Hoyle wrote:
> 
> 1) Is my problem 'expected' based on others' understanding of the
> current design of the scheduler, or do I have a one-off problem to
> troubleshoot here?

What kernel are you running (or did my eye glance over that detail in
your longish email) ?

> 2) Am I overlooking obvious alternative (but clean) fixes?

Maybe, we fixed a glaring bug in this department recently (or more even,
if you're on older than .28).

> 3) Does anyone else see the need for static, but low process priorities?

Yep, its rather common.

> 4) What is the view of introducing a new scheduler class to handle this?

We should have plenty available, SCHED_IDLE should just work -- as
should nice 19 for that matter.

