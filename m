Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYJ2QhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYJ2QhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYJ2QhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:37:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbYJ2QhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:37:11 -0400
Date: Wed, 29 Oct 2008 17:36:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] corruption checker: print the DMI board name on
	corruption
Message-ID: <20081029163657.GA15598@elte.hu>
References: <20081029091703.47628e54@infradead.org> <20081029092756.1e441b80@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029092756.1e441b80@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> Hi Linus,
> 
> would you consider merging this patch for 2.6.28 still?
> Without this patch, kerneloops.org only gets to see THAT corruption
> happens, but doesn't have information about what kind of system the
> corruption is happening on.. (which is the useful part to make a
> DMI blacklist).
> 
> So far we have 1 such report in kerneloops.org but it's useless... no
> system information.

such "improve our kerneloops.org yield" patches are fair game up to 
-rc7 or so i think.

	Ingo
