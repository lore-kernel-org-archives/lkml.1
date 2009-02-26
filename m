Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZBZSDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZBZSDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZBZSDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:03:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZBZSDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:03:22 -0500
Date: Thu, 26 Feb 2009 19:03:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable DMAR by default
Message-ID: <20090226180304.GA10940@elte.hu>
References: <20090226175756.GP6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226175756.GP6690@bombadil.infradead.org>
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


* Kyle McMartin <kyle@infradead.org> wrote:

> From: Kyle McMartin <kyle@redhat.com>
> 
> Now that the obvious bugs have been worked out, specifically 
> the iwlagn issue, and the write buffer errata, DMAR should be 
> safe to turn back on by default. (We've had it on since those 
> patches were first written a few weeks ago, without any 
> noticeable bug reports (most have been due to the dma-api 
> debug patchset.))
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> ---
> Probably 2.6.29 material, but should definitely go in for 2.6.30.

Definitely agreed on .30. Can do it in .29 as well if David and 
the rest of the Cc: agrees.

	Ingo
