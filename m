Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYIEUb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYIEUb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYIEUbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:31:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYIEUbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:31:19 -0400
Date: Fri, 5 Sep 2008 22:31:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: oprofile + hibernation = badness
Message-ID: <20080905203100.GA24193@elte.hu>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com> <20080901163452.GD6588@erda.amd.com> <20080905175827.GE27395@elte.hu> <20080905185907.GI5417@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905185907.GI5417@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 05.09.08 19:58:29, Ingo Molnar wrote:
> > > this fix (commit id 1404e403) is not yet upstream for v2.6.27. Could
> > > this be added to the next pull request?
> > 
> > it's already upstream, as commit 80a8c9fffa. I've zapped the duplicate 
> > 1404e403 from x86/oprofile.
> 
> Ah, I stumbled other this because it is still listed in the shortlog:
> 
>  $ git shortlog linux-2.6/master..tip/master | grep oprofile
>        x86: fix oprofile + hibernation badness
>  ...

yeah - it's still in the integration branch - but it doesnt hurt as it's 
same-content patch (it got cherry-picked over into an urgent branch). 
The duplication should go away on the next tip/master integration run 
(tomorrow-ish) - please let me know if it doesnt.

	Ingo
