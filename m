Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbXHCPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbXHCPNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXHCPNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:13:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50654 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbXHCPNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:13:40 -0400
Date: Fri, 3 Aug 2007 17:13:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "T. J. Brumfield" <enderandrew@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about modularization
Message-ID: <20070803151333.GB13619@elte.hu>
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com> <20070803131900.GA26203@elte.hu> <cdc89fe60708030651s54b5f0e0j938450632cf621c5@mail.gmail.com> <cdc89fe60708030652p634c6ea1y1f7b351f12a35a7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdc89fe60708030652p634c6ea1y1f7b351f12a35a7a@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* T. J. Brumfield <enderandrew@gmail.com> wrote:

> CFS is apparently better in its simplicity, however others are 
> reporting that SD still provides benefits for 3D gaming. [...]

even for 3D gaming the opposite of what you say seems to be the case:

  http://people.redhat.com/mingo/misc/cfs-sd-ut2004-perf.jpg
  http://people.redhat.com/mingo/misc/cfs-vs-sd-wine-quake.jpg

  ( more such measurements were done and reported, i stopped doing
    graphs after the first two. )

but in any case, the main "target" of CFS was not even SD (although it 
is certainly desirable to handle any load at least as well as SD) but 
the _mainline_ scheduler. SD was the primary selection of a relatively 
small subset of existing Linux users, and SD had known (and intentional) 
tradeoffs over the mainline scheduler in certain areas. CFS tried to do 
zero tradeoffs over the existing scheduler, to not introduce regressions 
to the many users who found the existing scheduler just good enough. 
That's been a success so far, at the moment there's no open CFS 
"interactivity regression" relative to the 2.6.22 mainline scheduler.

	Ingo
