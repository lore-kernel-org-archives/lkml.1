Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZAFMWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZAFMWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZAFMVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:21:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZAFMVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:21:53 -0500
Date: Tue, 6 Jan 2009 13:21:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: k8 numa register active regions later
Message-ID: <20090106122141.GB7071@elte.hu>
References: <4962C445.3090307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4962C445.3090307@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: clean up
> 
> don't register early, so we don't need to clear actived regions if it fail
> to get node hash shift or wild set in nb config.
> 
> also remove nodeids array that is not needed
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/k8topology_64.c |   20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)

applied to tip/x86/numa, thanks Yinghai!

	Ingo
