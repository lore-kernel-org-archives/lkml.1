Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXLGJpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXLGJpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXLGJpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:45:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbXLGJpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:45:08 -0500
Date: Fri, 7 Dec 2007 10:44:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Miles Lane <miles.lane@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86 vDSO: canonicalize sysenter .eh_frame
Message-ID: <20071207094439.GA26097@elte.hu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47587796.8020705@free.fr> <20071206143754.07a67819.akpm@linux-foundation.org> <20071207011429.EE2BC26F8D9@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207011429.EE2BC26F8D9@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Some assembler versions automagically optimize .eh_frame contents, 
> changing their size.  The CFI in sysenter.S was not using optimal 
> formatting, so it would be changed by newer/smarter assemblers. This 
> ran afoul of the wired constant for padding out the other vDSO images 
> to match its size.  This changes the original hand-coded source to use 
> the optimal format encoding for its operations.  That leaves nothing 
> more for a fancy assembler to do, so the sizes will match the wired-in 
> expected size regardless of the assembler version.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com> ---

thanks, applied.

	Ingo
