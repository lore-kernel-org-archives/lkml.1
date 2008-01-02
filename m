Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYABQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYABQLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYABQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:11:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35622 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYABQLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:11:25 -0500
Date: Wed, 2 Jan 2008 17:11:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [patch] asm-*/posix_types.h: scrub __GLIBC__
Message-ID: <20080102161108.GE21046@elte.hu>
References: <200801021005.33587.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801021005.33587.vapier@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier@gentoo.org> wrote:

> Some arches (like alpha and ia64) already have a clean posix_types.h 
> header. This brings all the others in line by removing all references 
> to __GLIBC__ (and some undocumented __USE_ALL).

i guess this should go in via -mm, as it affects all architectures. 
Also, Ulrich and Roland Cc:-ed.

	Ingo
