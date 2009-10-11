Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbZJKU5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbZJKU5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZJKU5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:57:50 -0400
Received: from mx19.lb01.inode.at ([62.99.145.21]:29726 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751663AbZJKU5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:57:50 -0400
Message-ID: <4AD246A3.5000700@sbg.ac.at>
Date: Sun, 11 Oct 2009 22:57:07 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (X11/20090826)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       alexander.huemer@sbg.ac.at
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200909251448.17671.elendil@planet.nl> <4ACDD45C.5090009@sbg.ac.at> <200910101513.51320.elendil@planet.nl>
In-Reply-To: <200910101513.51320.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know what vanilla-2.6.31-r2 is, but I assume it's based on
either 2.6.31.3 or 2.6.31.2.

    vanilla just means the unpatched kernel from kernel.org.

The most likely explanation is that your earlier test from which you
concluded that the revert did fix the problem was incorrect. It seems
unlikely that some other stable commit interferes here.

So basically we're back where we started.

    unfortunately you seem to be right.

How reproducible is the error for you? Do you see it every time or not?
If it is reliably reproducible, can you think of any explanation why your
earlier test was a success while we now see that the revert does not help?

    the error is reproducible. i'll try to pin it down to certain kernel
    versions in the next days.

Does the error *only* occur during gcc compilation, or was that just the
simplest way to reproduce it? Does it always occur at the same point during
the compilation or does it vary?

    it was the simplest way.
    i don't know how i could find out if the error actually always
    happens exactly the same time.
    i'll think about that.

Can you create a test case that does not require doing the whole
compilation, but only executes the step that triggers the error?

    surely, if i know what happens when the error occurs.

If you can find a reliable and fairly quick way to reproduce the error, I
would suggest doing a bisection.

    i would be happy to do that.

    thanks for now.

