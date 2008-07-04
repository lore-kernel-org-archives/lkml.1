Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYGDKeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYGDKeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYGDKd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:33:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYGDKd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:33:58 -0400
Date: Fri, 4 Jul 2008 12:33:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 0 of 8] x86/xen: updated physical mapping patches, and
	_PAGE_GLOBAL cleanup
Message-ID: <20080704103335.GA29615@elte.hu>
References: <patchbomb.1214955989@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1214955989@localhost>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's a revised series of the Xen-64 groundwork patches relating to 
> creating the physical memory mapping.  The first few patches are the 
> necessary changes to make it work without triggering CPA warnings, and 
> the last couple are cleanups of _PAGE_GLOBAL in the _PAGE_KERNEL 
> flags, and could probably happily live in another topic branch 
> (they're not at all Xen-specific or required for Xen to work).

well there are context dependencies so i've put them into x86/xen-64bit.

i picked up these four and merged them into tip/master:

Jeremy Fitzhardinge (4):
      x86_64/setup: unconditionally populate the pgd
      x86: always set _PAGE_GLOBAL in _PAGE_KERNEL* flags
      x86_32: remove __PAGE_KERNEL(_EXEC)
      x86/cpa: use an undefined PTE bit for testing CPA

the others were either already applied or didnt apply.

i'm still testing tip/master but i've pushed out these updates to 
x86/xen-64bit - you should be able to get the tree i'm testing by doing:

   git-checkout tip/master
   git-merge tip/x86/xen-64bit

	Ingo
