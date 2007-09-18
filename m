Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXIRG0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXIRG0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbXIRG03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:26:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbXIRG03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:26:29 -0400
Date: Tue, 18 Sep 2007 08:26:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Chris Rigg <cdrigg@comcast.net>, linux-kernel@vger.kernel.org
Subject: Re: CFS patch (v6) -- dynamic RT priorities?
Message-ID: <20070918062606.GA5138@elte.hu>
References: <46EEE498.1080500@comcast.net> <20070918050043.GE10199@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918050043.GE10199@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> On Mon, Sep 17, 2007 at 02:33:28PM -0600, Chris Rigg wrote:
> > Hello,
> > 
> > I have a system with 2.6.20.7 patched with the v6 CFS patch. I am having 
> > issues (I believe) with fairness in regards to my real-time tasks. 
> > First, let me describe my setup:
> 
> Chris,
> 
> CFSv6 is *very* old. It was not that bad, but looking back, it has 
> improved a lot since. You should upgrade to v20.x first, and it's 
> likely that most of your problems will vanish.

yeah. I remember we fixed something in the RT task balancing area too, 
so chances are that this bug got fixed. The latest backported CFS 
version can be picked up from:

    http://people.redhat.com/mingo/cfs-scheduler/

	Ingo
