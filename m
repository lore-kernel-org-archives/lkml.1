Return-Path: <linux-kernel-owner+w=401wt.eu-S934036AbYBGWU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbYBGWU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbYBGWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:20:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbYBGWUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:20:36 -0500
Date: Thu, 7 Feb 2008 23:20:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_COMPAT_BRK help text
Message-ID: <20080207222023.GA31437@elte.hu>
References: <ada8x1wa05p.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada8x1wa05p.fsf@cisco.com>
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


* Roland Dreier <rdreier@cisco.com> wrote:

> CONFIG_COMPAT_BRK=y means that heap randomization is turned off, so 
> it's *always* a safe choice.  I assume the help text is trying to say 
> that if one does not run ancient binaries, then enabling heap 
> randomization is safe.

> -	  On non-ancient distros (post-2000 ones) Y is usually a safe choice.
> +	  On non-ancient distros (post-2000 ones) N is usually a safe choice.

yeah - this typo fix is already in x86.git.

	Ingo
