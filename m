Return-Path: <linux-kernel-owner+w=401wt.eu-S965309AbXCFRM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309AbXCFRM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965970AbXCFRM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:12:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbXCFRMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:12:24 -0500
Date: Tue, 6 Mar 2007 18:11:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
Message-ID: <20070306171130.GA13403@elte.hu>
References: <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <20070306093436.GA30239@elte.hu> <45ED3F29.6000705@suse.de> <20070306102658.GA7478@elte.hu> <45ED4AD8.6020504@suse.de> <20070306115937.GA25313@elte.hu> <45ED9678.5050907@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED9678.5050907@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The whole point of pv_ops is to allow the hypervisors interfaces to 
> evolve at their own pace without having to constrain the core kernel's 
> development

unfortunately that's a self-serving oxymoron, contradicted by real life 
;) Pretty much the only way to ensure a sane ABI is to do it like we do 
it with the Linux syscall ABI:

	_to have only one_

We do not let OpenOffice or Evolution have its own separate ABI to Linux 
so that they 'can evolve at their own pace'... We want them to cooperate 
and come up with a common ABI (or rather, we try to come up with the 
right syscalls ourselves), because divering, overlapping ABIs are a huge 
PITA.

We do not unify their pointlessly diverging ABIs to within the kernel 
via say office_ops (while we could) because that's crappy on its face. 
Hypervisors arent in any way different, they just _think_ they are 
special because they are relatively new. But hey, i dont expect you to 
concede this point ;)

	Ingo
