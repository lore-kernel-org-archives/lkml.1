Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYJCID3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYJCID3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJCIDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:03:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbYJCIDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:03:05 -0400
Date: Fri, 3 Oct 2008 10:02:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: Implement personality ADDR_LIMIT_32BIT
Message-ID: <20081003080244.GC25408@elte.hu>
References: <1223017469-5158-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223017469-5158-1-git-send-email-kirill@shutemov.name>
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


* Kirill A. Shutemov <kirill@shutemov.name> wrote:

> -	/* for MAP_32BIT mappings we force the legact mmap base */
> -	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT))
> +	/* for MAP_32BIT mappings and ADDR_LIMIT_32BIT personality we force the
> +	 * legact mmap base
> +	 */

please use the customary multi-line comment style:

  /*
   * Comment .....
   * ...... goes here:
   */

and you might use the opportunity to fix the s/legact/legacy typo as 
well.

but more generally, we already have ADDR_LIMIT_3GB support on x86. Why 
should support for ADDR_LIMIT_32BIT be added?

	Ingo
