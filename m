Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbXJ3BIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbXJ3BIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbXJ3BIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:08:31 -0400
Received: from www.tglx.de ([62.245.132.106]:38338 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXJ3BIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:08:31 -0400
Date: Tue, 30 Oct 2007 02:06:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Arjan van de Ven <arjan@infradead.org>, vgoyal@in.ibm.com,
       hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Revert x86: add lapic_shutdown for x86_64
In-Reply-To: <4726753D.3010601@ct.jp.nec.com>
Message-ID: <alpine.LFD.0.9999.0710300203040.3186@localhost.localdomain>
References: <47195763.1090803@ct.jp.nec.com> <47195807.6030809@ct.jp.nec.com> <20071024062933.GA4622@in.ibm.com> <47266132.5050001@ct.jp.nec.com> <20071029161534.6e7f0db6@laptopd505.fenrus.org> <4726753D.3010601@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Hiroshi Shimamoto wrote:

> Arjan van de Ven wrote:
> > On Mon, 29 Oct 2007 15:39:46 -0700
> > Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> > 
> >> lapic_shutdown is useless on x86_64.
> >>
> > 
> > .... but since the goal is to get apic_32.c and apic_64.c to be more
> > converging (to the point of becoming the same file)... isn't your patch
> > going in the opposite direction?
> > 
> Hmm, I'm not sure that this revert affects x86 unification.
> Vivek said that probably we don't have to introduce lapic_shutdown() for 64bit.
> So I submitted this patch which reverts my previous post, it was applied before
> the comment.

Don't worry, we sort this out. There is some inevitable friction loss
for now, but we are getting closer. I gave the apic code some care to
get a readable diff out of it. Result is in:

git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git cleanup

Thanks,

	tglx
