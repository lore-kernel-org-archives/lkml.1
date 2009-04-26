Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZDZJcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZDZJcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZDZJbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:31:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45566 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZDZJbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:31:50 -0400
Date: Sun, 26 Apr 2009 11:31:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [Bug #13185] New x86 warning
Message-ID: <20090426093103.GA19267@elte.hu>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.07B.qc48JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Fg2zLW93smL.A.07B.qc48JB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13185
> Subject		: New x86 warning
> Submitter	: Jeff Garzik <jeff@garzik.org>
> Date		: 2009-04-22 6:46 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=124038280020950&w=4

I saw this warning with certain GCC versions for several kernel 
cycles, so it's not any recent change that triggers this and it is 
not a regression.

GCC is simply wrong here - i have posted a workaround for that but 
it is too ugly to be merged upstream.

> Handled-By	: Andi Kleen <andi@firstfloor.org>
> Patch		: http://patchwork.kernel.org/patch/19330/
> 		  http://patchwork.kernel.org/patch/19406/

This patch regresses on older GCC versions and doesnt really address 
the GCC false positive warning either, it just removes the inline 
function that triggers the warning.

	Ingo
