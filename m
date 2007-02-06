Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbXBFUgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbXBFUgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXBFUgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:36:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbXBFUgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:36:35 -0500
Date: Tue, 6 Feb 2007 21:36:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
Message-ID: <20070206203638.GA23716@elte.hu>
References: <45C85097.1000106@in.ibm.com> <20070206021300.698ecb2c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206021300.698ecb2c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4504]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 06 Feb 2007 15:25:35 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> 
> >         I have developed a patch, that lists all active probes in 
> > the system.
> 
> userspace added the probes, so userspace should know where they all 
> are?

it's a kernel resource that user-space can influence so it's sensible to 
have some sort of visibility to them. For example if the userspace that 
has the 'info' crashes then another piece of user-space might want to 
recreate that info, to zap the probes.

also, this resource could leak, etc.

	Ingo
