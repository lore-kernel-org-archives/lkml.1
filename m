Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbZBNXb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbZBNXb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbZBNXX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:23:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221AbZBNXXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:23:55 -0500
Date: Sun, 15 Feb 2009 00:23:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rogier Wolff <R.E.Wolff@bitwizard.nl>
Subject: Re: [Bug #12265] FPU emulation broken in 2.6.28-rc8 ?
Message-ID: <20090214232335.GG20477@elte.hu>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.kaB.Y50lJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ROx6X68CGJG.A.kaB.Y50lJB@chimera>
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
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12265
> Subject		: FPU emulation broken in 2.6.28-rc8 ?
> Submitter	: Rogier Wolff <R.E.Wolff@bitwizard.nl>
> Date		: 2008-12-17 8:56 (60 days old)
> References	: http://marc.info/?l=linux-kernel&m=122950463030747&w=4

Should be fixed in -rc5 by:

  d315760: x86: fix math_emu register frame access

Rogier, can you confirm?

	Ingo
