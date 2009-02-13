Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZBMK2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZBMK2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZBMK2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:28:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZBMK2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:28:01 -0500
Date: Fri, 13 Feb 2009 11:27:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, linux-api@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: What can OpenVZ do?
Message-ID: <20090213102732.GB4608@elte.hu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu> <1234285547.30155.6.camel@nimitz> <20090211141434.dfa1d079.akpm@linux-foundation.org> <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234475483.30155.194.camel@nimitz>
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


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> > If so, perhaps that can be used as a guide.  Will the planned feature
> > have a similar design?  If not, how will it differ?  To what extent can
> > we use that implementation as a tool for understanding what this new
> > implementation will look like?
> 
> Yes, we can certainly use it as a guide.  However, there are some
> barriers to being able to do that:
> 
> dave@nimitz:~/kernels/linux-2.6-openvz$ git diff v2.6.27.10... | diffstat | tail -1
>  628 files changed, 59597 insertions(+), 2927 deletions(-)
> dave@nimitz:~/kernels/linux-2.6-openvz$ git diff v2.6.27.10... | wc 
>   84887  290855 2308745
> 
> Unfortunately, the git tree doesn't have that great of a history.  It
> appears that the forward-ports are just applications of huge single
> patches which then get committed into git.  This tree has also
> historically contained a bunch of stuff not directly related to
> checkpoint/restart like resource management.

Really, OpenVZ/Virtuozzo does not seem to have enough incentive to merge
upstream, they only seem to forward-port, keep their tree messy, do minimal
work to reduce the cross section to the rest of the kernel (so that they can
manage the forward ports) but otherwise are happy with their carved-out
niche market. [which niche is also spiced with some proprietary add-ons,
last i checked, not exactly the contribution environment that breeds a
healthy flow of patches towards the upstream kernel.]

Merging checkpoints instead might give them the incentive to get
their act together.

	Ingo
