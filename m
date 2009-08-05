Return-Path: <linux-kernel-owner+w=401wt.eu-S933710AbZHEIHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710AbZHEIHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZHEIHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:07:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48977 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZHEIHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:07:03 -0400
Date: Wed, 5 Aug 2009 10:06:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Tan, Wei Chong" <wei.chong.tan@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Message-ID: <20090805080647.GC30307@elte.hu>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <B28277FD4E0F9247A3D55704C440A140D5ADEC74@pgsmsx504.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B28277FD4E0F9247A3D55704C440A140D5ADEC74@pgsmsx504.gar.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tan, Wei Chong <wei.chong.tan@intel.com> wrote:

> > Here's a suggested replacement - BUT NOTE THAT IT'S ENTIRELY 
> > UNTESTED!
> > 
> > (Ok, so the patch is bigger than it strictly needs to be - I 
> > hate repeating code, so I made that 'read PIT counter twice and 
> > compare MSB' be a new helper routine)
> > 
> > Hmm? What do you guys think?
> 
> Hi,
> 
> We are performing some test on the patch and will keep everyone 
> posted with the progress soon.

Thanks. I've zapped the original patch from x86/urgent. Linus's 
patch certainly looks feasible for .31 if it solves the problem and 
if we can merge it in the next few days.

	Ingo
