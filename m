Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbXH2EA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbXH2EA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbXH2EAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:00:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXH2EAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:00:20 -0400
Date: Wed, 29 Aug 2007 06:00:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: Linux 2.6.23-rc4, maxcpus=1 regression
Message-ID: <20070829040011.GA3936@elte.hu>
References: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org> <20070829035554.GA838@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829035554.GA838@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0865]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> maxcpus=1 fails to boot on my T60 laptop, it hangs in early bootup 
> (right after setting up the local APICs). I bisected it down to this 
> recent commit:

maxcpus=0 fails to boot as well.

	Ingo
