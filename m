Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYLUIOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYLUIOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYLUIOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:14:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbYLUIOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:14:24 -0500
Date: Sun, 21 Dec 2008 09:14:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [Bug #12156] v2.6.28-rc2: x86_32 relocation regression?
Message-ID: <20081221081406.GB4773@elte.hu>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <vy-yJy0f3YP.A.yhB.qaYTJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vy-yJy0f3YP.A.yhB.qaYTJB@chimera>
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
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12156
> Subject		: v2.6.28-rc2: x86_32 relocation regression?
> Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
> Date		: 2008-11-24 21:19 (27 days old)
> References	: http://marc.info/?l=linux-kernel&m=122756158220966&w=4

not really a regression but a long-standing inconvenience/bug of the debug 
symbols of relocatable kernels. (ever since relocatable kernels were added 
in '06 or so.) Nevertheless we queued up a revert of the defconfig change 
for .29, to not expose it in the defconfig:

 f269b07: x86: revert CONFIG_RELOCATABLE=y defconfig change

so i think it can be taken off the regressions list.

	Ingo
