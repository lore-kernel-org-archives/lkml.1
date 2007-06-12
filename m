Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbXFLOE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbXFLOE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXFLOET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:04:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37022 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbXFLOES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:04:18 -0400
Date: Tue, 12 Jun 2007 16:04:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tobias Gerschner <tobias.gerschner@gmail.com>
Cc: Miguel Figueiredo <elmig@debianpt.org>, ck@vds.kolivas.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck]
	Mainline plans)
Message-ID: <20070612140407.GA19543@elte.hu>
References: <466DE921.9030709@debianpt.org> <ea7e82ce0706120039n675a361emc214b2ecca964b75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea7e82ce0706120039n675a361emc214b2ecca964b75@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Tobias Gerschner <tobias.gerschner@gmail.com> wrote:

> The output of massive_intr can be found here :
> http://www.yoper.com/scheduler-test/

here's the spread of the massive_intr results (the average 'jitter' of 
the second column of the results - lower values are indicating more 
stable / more fair massive_intr results, in percentage):

               CFS         SD
            ----------------------
     10:       0.02       0.55
     20:       0.21       0.78
     30:       0.26       0.95
     40:       0.27       1.46
     50:       0.37       1.24
     60:       0.37       0.92

but of course i'm primarily interested is the observed difference in 
interactivity :-)

	Ingo
