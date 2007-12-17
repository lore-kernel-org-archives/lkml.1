Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXLQOer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXLQOer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXLQOel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:34:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbXLQOek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:34:40 -0500
Date: Mon, 17 Dec 2007 15:34:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>,
       mingo@redhat.com, Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] x86: fix ref-counting bug in change_page_attr()
Message-ID: <20071217143414.GB13290@elte.hu>
References: <47610AB5.76E4.0078.0@novell.com> <20071217132802.GD1870@elte.hu> <47668A82.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47668A82.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> > hm, does this patch fix any real bug seen live? (if yes then do you 
> > have links to it, etc?) It would be a v2.6.24 fix in theory but it 
> > looks too dangerous for that. So i've queued it up for v2.6.25, for 
> > the time being.
> 
> I had run into the issue with experimental code of mine quite a while 
> back (i.e. I don't even recall what exactly I was doing back then). 
> After that I just continued to keep the fix (which I had submitted 
> before, but which collided with something in Andi's tree back then 
> iirc).

i'd be inclined to have it in the for-2.6.25 queue then - even plain 
bugfixes in the pageattr code have broken boxes in the past, so this 
isnt something we want to touch so late in the cycle. (We can still 
reprioritize it if a serious regression pops up that this addresses.)

	Ingo
