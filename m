Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbYDUTwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbYDUTwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYDUTwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:52:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbYDUTwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:52:06 -0400
Date: Mon, 21 Apr 2008 21:51:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421195148.GG8770@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <1208793533.3640.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208793533.3640.24.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > thanks, the three patches below should fix it.
> > 
> > i ended up excluding Voyager configs from our test space some time 
> > ago (and VISWS as well - there's one more visws fix in x86.git), 
> > that's how this broke. These subarchitectures seem not to be used at 
> > all and the code wont boot on normal PCs. We could mark it BROKEN 
> > but the fix seems simple in any case.
> 
> The voyager pieces of this code look fine to me.  I can't test at the 
> moment because we're having the carpets cleaned and I can't get down 
> into the cellar where the systems are, but I'll do so shortly.

ok, that's good enough - that's why i excluded it from the auto-qa 
test-space as well. Adrian, could you please remove it from your config 
testset as well? If a user enables that config option it wont boot 
anyway so it's not a problem in practice.

	Ingo
