Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZBNXRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZBNXRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZBNXIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:08:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbZBNXIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:08:39 -0500
Date: Sun, 15 Feb 2009 00:08:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, orenl@cs.columbia.edu,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Message-ID: <20090214230802.GE20477@elte.hu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu> <1234285547.30155.6.camel@nimitz> <20090211141434.dfa1d079.akpm@linux-foundation.org> <1234462282.30155.171.camel@nimitz> <20090213152836.0fbbfa7d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213152836.0fbbfa7d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Similar to the way in which perfectly correct and normal kernel
> sometimes has to be changed because it unexpectedly upsets the -rt
> patch.

Actually, regarding -rt, we try to keep that in two buckets:

 1) Normal kernel code works but is unclean or structured less
    than ideal. In this case we restructure the mainline code,
    but that change stands on its own four legs, without any
    -rt considerations.

 2) Normal kernel code that is clean - i.e. a change that only
    matters to -rt. In this case we dont touch the mainline code,
    nor do we bother mainline.

Do you know any specific example that falls outside of those categories?

	Ingo
