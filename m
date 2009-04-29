Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZD2UZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZD2UZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbZD2UYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:24:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59031 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460AbZD2UYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:24:51 -0400
Date: Wed, 29 Apr 2009 22:24:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <kees@ubuntu.com>, Arjan van de Ven <arjan@infradead.org>,
       Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CC_STACKPROTECTOR vs CC_STACKPROTECTOR_ALL
Message-ID: <20090429202415.GB21421@elte.hu>
References: <20090429195453.GE8586@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429195453.GE8586@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Kees Cook <kees@ubuntu.com> wrote:

> Hi,
> 
> What is the rationale for why CC_STACKPROTECTOR_ALL is forced when 
> using CC_STACKPROTECTOR?  I would have expected _ALL to be a 
> separate option (as it was in earlier versions), but it seems it 
> is forced on by commit 113c5413cf9051cc50b88befdc42e3402bb92115.

it used to be a separate option. I merged them into one, because we 
had too many options really, and because the vmsplice exploit would 
only have been caught by the _ALL variant. So the 'light' variant 
never really worked well IMO.

	Ingo
