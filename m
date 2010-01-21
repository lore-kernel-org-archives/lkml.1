Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278Ab0AUK5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0AUK5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060Ab0AUK5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:57:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:40679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0AUK47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:56:59 -0500
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>
In-Reply-To: <20100121105311.GB5017@nowhere>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>
	 <Pine.LNX.4.64.1001192155490.28583@ask.diku.dk>
	 <1263935333.4561.26.camel@frodo>
	 <Pine.LNX.4.64.1001211145480.13529@ask.diku.dk>
	 <20100121105311.GB5017@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 11:56:53 +0100
Message-ID: <1264071413.4283.1155.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:53 +0100, Frederic Weisbecker wrote:

> Looks fine as spin_unlock includes a memory barrier, IIRC.

It doesn't actually, see Documentation/memory-barriers.txt

