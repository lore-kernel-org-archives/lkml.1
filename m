Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYKIVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYKIVQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYKIVQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:16:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:48480 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbYKIVQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:16:04 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <wnN9HICUAgP.A._d.f5zFJB@chimera>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 08:15:31 +1100
Message-Id: <1226265331.13603.96.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-09 at 18:59 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11875
> Subject		: radeonfb lockup in .28-rc (bisected)
> Submitter	: James Cloos <cloos@jhcloos.com>
> Date		: 2008-10-28 0:00 (13 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
> References	: http://marc.info/?l=linux-kernel&m=122515210200530&w=4
> Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 

FYI. I'm back at work today, at which point I'll have a similar machine
to one of the victims which should allow me to either reproduce & fix,
or if I can't, send a workaround in the form of disabling that
specific acceleration unless explicitely enabled from the command line.

So expect a patch later today.

Cheers,
Ben.


