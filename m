Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZESMim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZESMim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZESMif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:38:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZESMif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:38:35 -0400
Date: Tue, 19 May 2009 14:37:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090519123728.GA2377@elte.hu>
References: <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu> <4A12A05C.6050004@redhat.com> <20090519122623.GD14305@elte.hu> <20090519133206.173a2ddf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519133206.173a2ddf@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > - or introduce its own hypercall API based administration API,
> >   without bothering the guest kernel with crap. Trivially patch Xorg
> >   to make use of it and that's it.
> 
> PCI pass through mixed with that isn't going to be fun and PCI 
> pass through is one area where a lot of the MTRR manipulation is 
> meaningful and valid (and can be handled for the guest).

virtualizing that aspect of the CPU properly is certainly the 
highest grade approach.

> I really don't see why rd/wrmsr processing isn't sufficient for 
> this

/me neither.

	Ingo
