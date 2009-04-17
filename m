Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbZDQAsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbZDQAsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbZDQApZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:45:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760905AbZDQApW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:45:22 -0400
Date: Fri, 17 Apr 2009 02:45:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #13099] net, sky2: BUG: unable to handle kernel NULL
	pointer dereference, pci_vpd_truncate()
Message-ID: <20090417004517.GB1988@elte.hu>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.Q2.cw85JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nY3-4PrO6XH.A.Q2.cw85JB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13099
> Subject		: net, sky2: BUG: unable to handle kernel NULL pointer dereference, pci_vpd_truncate()
> Submitter	: Ingo Molnar <mingo@elte.hu>
> Date		: 2009-04-06 9:03 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=123900867611321&w=4
> Handled-By	: Stephen Hemminger <shemminger@vyatta.com>

I think this can be closed as the fix has been merged upstream 
already (via the PCI tree):

 commit d407e32efe060afa2b9a797a91376ebc65b4ce11
 Author: Anton Vorontsov <avorontsov@ru.mvista.com>
 Date:   Wed Apr 1 02:23:41 2009 +0400

    PCI: Fix oops in pci_vpd_truncate

	Ingo
