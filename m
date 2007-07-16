Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbXGPI3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbXGPI3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXGPI3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:29:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60947 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbXGPI3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:29:24 -0400
Date: Mon, 16 Jul 2007 10:29:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ni@m" <niam.niam@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: performance -cfs19 vs. -ck1 for 2.6.22
Message-ID: <20070716082917.GA1325@elte.hu>
References: <a9e22dff0707160112pc3b7bfcmc73adbd4edec670e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9e22dff0707160112pc3b7bfcmc73adbd4edec670e@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ni@m <niam.niam@gmail.com> wrote:

> Using 2.6.22 or 2.6.22-cfs19 my firefox hangs for some time(~4-5 
> seconds) when I'm trying to open any url, but with 2.6.22-ck1 firefox 
> doesn't hang at all or at least for a second when I have lots of open 
> tabs.

hm, is there no other workload on the system? Could you run the 
following script:

   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

while you are busy opening new tabs on a CFSv19 kernel (and send me the 
file it outputs)?

One way to start up the script precisely would be to start it in a 
terminal like this:

  sleep 10; echo "soon ..."; sleep 1; ./cfs-debug-info.sh

that way you have 10 seconds to switch from the terminal to firefox, and 
you can time the delay of firefox precisely on the start-time of the 
debug script.

	Ingo
