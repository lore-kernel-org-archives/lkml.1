Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZE0VTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZE0VTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZE0VTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:19:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZE0VTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:19:08 -0400
Date: Wed, 27 May 2009 23:18:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
Message-ID: <20090527211828.GA6166@elte.hu>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org> <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 27 May 2009, Jeremy Fitzhardinge wrote:
> > 
> > [ Impact: prevent MSI subsystem from crashing ]
> 
> Grr.
> 
> I looked at several of these impact lines, and they were _all_ totally 
> misleading.
> 
> Please, guys. Stop with the F*CKING impact lines already. Add them 
> if they are obvious, but don't make them this idiotic "do an 
> impact line whether or not it makes sense".
> 
> I hate them. They are stupid. 90% of all the impact lines I see 
> are either (a) misleading or (b) totally inane and pointless.
> 
> In this case, we would have been a LOT BETTER OFF with having just 
> a better header line that said "xen: disable MSI to avoid crash" 
> or something like that. But no. THAT F*CKING IMPACT LINE 
> apparently meant that Jeremy just turned off his brain, and made 
> _both_ the header line and the Impact: line be non-descriptive.
> 
> Really. Stop it. Ingo, start saying "no" to people, at least for 
> impact lines that do not make sense. It adds _nothing_, and it 
> actually detracts from real content, because just the inanity of 
> them delutes the whole meaning of it.

hm, i have to concur. Too often it ends up splitting attention away 
from the title of the commit. I do reject (or fix up) bad impact 
lines - will stop doing them altogether if you think there's a net 
downside to them ...

	Ingo
