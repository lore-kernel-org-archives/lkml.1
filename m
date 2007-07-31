Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXGaJp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXGaJp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXGaJps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:45:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbXGaJpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:45:47 -0400
Date: Tue, 31 Jul 2007 11:45:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kenneth Prugh <ken69267@gmail.com>
Cc: John <darknessenvelops@gmail.com>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070731094526.GA16300@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <46AE25F3.7020904@gmail.com> <20070730191029.GA29327@elte.hu> <46AE570B.3050802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AE570B.3050802@gmail.com>
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


* Kenneth Prugh <ken69267@gmail.com> wrote:

> Alright, Just got done with some testing of UT2004 between 2.6.23-rc1 
> CFS and 2.6.22-ck1 SD. This series of tests was run by spawning in a 
> map while not moving at all and always facing the same direction, 
> while slowing increasing the number of loops.
> 
> CFS generally seemed a lot smoother as the load increased, while SD 
> broke down to a highly unstable fps count that fluctuated massively 
> around the third loop. Seems like I will stick to CFS for gaming now.
> 
> Below you will find the results of my test with the average number of 
> FPS.

Thanks Kenneth for the testing! I've created a graph out of your 
numbers:

  http://people.redhat.com/mingo/misc/cfs-sd-ut2004-perf.jpg

(it also includes the SD numbers you got with the turn-yield-into-NOP 
hack applied.)

	Ingo
