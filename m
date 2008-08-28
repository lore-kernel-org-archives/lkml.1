Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYH1Jib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYH1Jib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYH1JiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:38:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYH1JiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:38:23 -0400
Date: Thu, 28 Aug 2008 11:38:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] shrink printk timestamp field
Message-ID: <20080828093806.GB28783@elte.hu>
References: <20080827151759.GA10678@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827151759.GA10678@tsunami.ccur.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0275]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Korty <joe.korty@ccur.com> wrote:

> Shrink the printk timestamp field.
> 
> Keep the printk timestamp from occupying more of the
> scarce, 80-column console line space than it really needs.
> 
> We eliminate the excessive whitespace the field added to
> the line, and reduce timestamp precision from six digits
> (usecs) to three digits (msecs).  msecs seems adequate
> for the purpose of tracking boot sequence timing issues.
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>

applied to tip/core/printk, thanks Joe.

	Ingo
