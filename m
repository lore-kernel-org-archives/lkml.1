Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYHOLht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYHOLht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYHOLhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:37:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYHOLhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:37:40 -0400
Date: Fri, 15 Aug 2008 13:37:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86_64: uml: fix rename header guard
Message-ID: <20080815113719.GA31348@elte.hu>
References: <48A4CD01.9080805@ct.jp.nec.com> <19f34abd0808142333t71ed91a2w9e4f16b8c4e1ee5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808142333t71ed91a2w9e4f16b8c4e1ee5b@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Fri, Aug 15, 2008 at 2:25 AM, Hiroshi Shimamoto
> <h-shimamoto@ct.jp.nec.com> wrote:
> > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >
> > In unistd_64.h, the guard macro _ASM_X86_64_UNISTD_H_ is renamed to
> > ASM_X86__UNISTD_64_H.
> >
> > This change should be applied to arch/um/sys-x86_64/syscall_table.c.
> >
> > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> I guess I screwed up again. Forgot to look for #undefs :-(

that's OK from a change of this width. And the #undefs are definitely 
#unnice as well.

	Ingo
