Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbXGPIUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbXGPIUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXGPIUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:20:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbXGPIUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:20:32 -0400
Date: Mon, 16 Jul 2007 10:20:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Message-ID: <20070716082025.GA29529@elte.hu>
References: <46946E39.5090108@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46946E39.5090108@bigpond.net.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> Probably the last one now that CFS is in the main line :-(.

hm, why is CFS in mainline a problem? The CFS merge should make the life 
of development/test patches like plugsched conceptually easier. (it will 
certainly cause a lot of churn, but that's for the better i think.)

Most of the schedulers in plugsched should be readily adaptable to the 
modular scheduling-policy scheme of the upstream scheduler. I'm sure 
there will be some minor issues as isolation of the modules is not 
enforced right now - and i'd be happy to review (and potentially apply) 
common-sense patches that improve the framework.

	Ingo
