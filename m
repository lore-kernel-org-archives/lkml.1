Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYBKOmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYBKOmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYBKOmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:42:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYBKOml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:42:41 -0500
Date: Mon, 11 Feb 2008 15:42:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Hellwig <hch@infradead.org>, sam@ravnborg.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 8/8] Move RODATA and NX tests to tests/
Message-ID: <20080211144205.GA26943@elte.hu>
References: <20080211104452.GB7944@in.ibm.com> <20080211105229.GJ7944@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211105229.GJ7944@in.ibm.com>
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


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Move RODATA and NX testcases to tests/

i'm not sure this is the proper place for it - it's highly x86 specific. 
arch/x86/tests sounds like the better place for it.

	Ingo
