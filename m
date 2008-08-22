Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYHVD4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYHVD4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYHVD41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:56:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40530 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYHVD40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:56:26 -0400
Date: Fri, 22 Aug 2008 05:56:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Joshua Hoblitt <josh@hoblitt.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822035609.GD30284@elte.hu>
References: <20080822001047.GF23377@hoblitt.com> <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com> <20080822002952.GG23377@hoblitt.com> <20080822010014.GH23377@hoblitt.com> <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822035024.GB30284@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i've tidied up your patch (see the commit below) and have queued it up 
> in x86/urgent. It seems fairly safe and i guess we can push it to 
> v2.6.27 if Joshua reports test success. Joshua, could you give it a go 
> please?

or just try the latest tip/master - please check whether you are getting 
the right amount of RAM out of box plus this warning message:

> WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");

	Ingo
