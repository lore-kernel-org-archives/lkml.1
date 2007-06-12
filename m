Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbXFLI4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbXFLI4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXFLIz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:55:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbXFLIzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:55:55 -0400
Date: Tue, 12 Jun 2007 10:55:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tobias Gerschner <tobias.gerschner@gmail.com>
Cc: Miguel Figueiredo <elmig@debianpt.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck]
	Mainline plans)
Message-ID: <20070612085545.GA18553@elte.hu>
References: <466DE921.9030709@debianpt.org> <ea7e82ce0706120039n675a361emc214b2ecca964b75@mail.gmail.com> <20070612083620.GA10557@elte.hu> <ea7e82ce0706120151q6c69ec65rbf21dc209255d040@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea7e82ce0706120151q6c69ec65rbf21dc209255d040@mail.gmail.com>
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

> it's a peacock freeliner xp II. Close to 5 year old Laptop with an 
> Athlon XP 2600+ using 1 GB of RAM / no swap enabled.
> 
> The other information will be sent as soon as I am back at work .

thanks! Here's another thing that would be worth testing:

could you pin the CPU's frequency to the highest setting (via whatever 
method of your choice, by selecting the 'performance' cpufreq governor 
for example). Plus could you do a test with the following additional 
kernel boot parameter: idle=poll. [both changes would exclude TSC 
related artifacts.] (This would be for testing only, to narrow down the 
regression.)

	Ingo
