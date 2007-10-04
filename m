Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbXJDXkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbXJDXkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbXJDXkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:40:09 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2111 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389AbXJDXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:40:07 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: SLUB performance regression vs SLAB
Date: Thu, 4 Oct 2007 16:39:53 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEFNHEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071004.134834.112622292.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 04 Oct 2007 16:39:57 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 04 Oct 2007 16:39:59 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


David Miller wrote:

> Using an unpublishable benchmark, whose results even cannot be
> published, really stretches the limits of "reasonable" don't you
> think?
>
> This "SLUB isn't ready yet" bullshit is just a shamans dance which
> distracts attention away from the real problem, which is that a
> reproducable, publishable test case, is not being provided to the
> developer so he can work on fixing the problem.
>
> I can tell you this thing would be fixed overnight if a proper test
> case had been provided by now.

I would just like to echo what you said just a bit angrier. This is the same
as someone asking him to fix a bug that they can only see with a binary-only
kernel module. I think he's perfectly justified in simply responding "the
bug is as likely to be in your code as mine".

Now, just because he's justified in doing that doesn't mean he should. I
presume he has an honest desire to improve his own code and if they've found
a real problem, I'm sure he'd love to fix it.

But this is just a preposterous position to put him in. If there's no
reproduceable test case, then why should he care that one program he can't
even see works badly? If you care, you fix it.

Matthew Wilcox wrote:

> Yet here we stand.  Christoph is aggressively trying to get slab removed
> from the tree.  There is a testcase which shows slub performing worse
> than slab.  It's not my fault I can't publish it.  And just because I
> can't publish it doesn't mean it doesn't exist.

It means it may or may not exist. All we have is your word that slub is the
problem. If I said I found a bug in the Linux kernel that caused it to panic
but I could only reproduce it with the nVidia driver, I'd be laughed at.

It may even be that slub is better, your benchmark simply interprets this as
worse. Without the details of your benchmark, we can't know. For example,
I've seen benchmarks that (usually unintentionally) actually do a *variable*
amount of work and details of the implementation may result in the benchmark
actually doing *more* work, so it taking longer does not mean it ran slower.

DS


