Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbXEXJ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbXEXJ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXEXJ6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:58:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54821 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbXEXJ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:58:00 -0400
Date: Thu, 24 May 2007 11:57:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: righiandr@users.sourceforge.net, Bernd Eckenfels <ecki@lina.inka.de>,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/2] limit print_fatal_signal() rate (was: [RFC] log out-of-virtual-memory events)
Message-ID: <20070524095746.GA15369@elte.hu>
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net> <464ED258.2010903@users.sourceforge.net> <20070520203123.5cde3224.akpm@linux-foundation.org> <20070524075835.GC21138@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524075835.GC21138@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] The only add-on change should be to not print SIGKILL events.

ah, that's already included in the version in -mm.

admittedly, the #ifdef __i386__ is quite lame, but there's no generic 
safely-try-to-show-code-at-addr function available at the moment.

	Ingo
