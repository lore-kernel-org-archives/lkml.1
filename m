Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbYD1R3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbYD1R3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbYD1R2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:28:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935834AbYD1R2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:28:30 -0400
Date: Mon, 28 Apr 2008 19:28:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix  max-stack calculators to skip canary
Message-ID: <20080428172812.GD23620@elte.hu>
References: <480D5F27.1030101@redhat.com> <20080422084404.GA2388@elte.hu> <480E15DC.5040301@sandeen.net> <480E1DED.9040104@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E1DED.9040104@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0046]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Sandeen <sandeen@sandeen.net> wrote:

> With the canary on the end of the stack, anything which looks for 0 to 
> mean unused when calculating max stack excursions must skip over this 
> non-zero magic number.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

thanks Eric, applied.

	Ingo
