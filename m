Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYCCKSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYCCKSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYCCKSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:18:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbYCCKSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:18:11 -0500
Date: Mon, 3 Mar 2008 11:17:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: SCHED_IDLE documentation
Message-ID: <20080303101751.GA21190@elte.hu>
References: <1203376368.275756.252634247263.1.gpush@pokey> <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de> <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu> <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com> <20080303092422.GA18281@elte.hu> <cfd18e0f0803030207j73da3172mf9470859bb918546@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0803030207j73da3172mf9470859bb918546@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> >  commit 0e6aca43e08a62a48d6770e9a159dbec167bf4c6
> >  Author: Ingo Molnar <mingo@elte.hu>
> >  Date:   Mon Jul 9 18:51:57 2007 +0200
> 
> Yep -- I found it later -- thanks.
> 
> Ingo, could you please CC me when kernel-userland API changes go into 
> mainline?  Otherwise, they potentially end up undocumented, and 
> un(der)used.

sure.

We could also add an in-commit-message marker for such changes, that you 
could periodically scan. Something like:

   User-ABI-extended-by: Ingo Molnar <mingo@elte.hu>

and:

   User-ABI-modified-by: Ingo Molnar <mingo@elte.hu>

that way you also know whom to contact about followup questions.

Declaring such changes would have other benefits as well: the review 
process becomes more streamlined. Also, any ABI side-effect would be 
known to be intentional versus unintentional, based on the commit 
headers alone. Undeclared ABI side-effects would be frowned upon and 
would be strong grounds for immediate reversal as well.

	Ingo
