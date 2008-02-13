Return-Path: <linux-kernel-owner+w=401wt.eu-S1766007AbYBMI5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766007AbYBMI5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbYBMI4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:56:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbYBMI4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:56:45 -0500
Date: Wed, 13 Feb 2008 09:56:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Amit Shah <amitshah@gmx.net>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080213085627.GA20765@elte.hu>
References: <20080130011550.GA31853@elte.hu> <f77718aa0802090611n240bfa5avbbe2abeb53607f48@mail.gmail.com> <Pine.LNX.4.64.0802101326270.7699@twin.jikos.cz> <877aabc40802112316t21d03114mc5b1f0411c019955@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877aabc40802112316t21d03114mc5b1f0411c019955@mail.gmail.com>
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


* Amit Shah <amitshah@gmx.net> wrote:

> > As far as I remembers, Ubuntu uses klibc in initramfs, right?
> >
> > What version of klibc do you have? There was a bug in klibc that 
> > causes such behavior on PIE-randomization-enabled kernels, and has 
> > been fixed in klibc-1.45 by commit [1]. Please make sure you have 
> > updated klibc version that doesn't contain this bug.
> 
> Thanks Jiri.

so your problem was resolved by an updated klibc version?

	Ingo
