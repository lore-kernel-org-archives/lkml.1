Return-Path: <linux-kernel-owner+w=401wt.eu-S1161892AbXECNCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161892AbXECNCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161893AbXECNCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:02:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161892AbXECNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:02:08 -0400
Date: Thu, 3 May 2007 15:02:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zoltan Boszormenyi <zboszor@dunaweb.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503130201.GA9000@elte.hu>
References: <46399B51.9040608@dunaweb.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46399B51.9040608@dunaweb.hu>
User-Agent: Mutt/1.4.2.2i
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


* Zoltan Boszormenyi <zboszor@dunaweb.hu> wrote:

> I started up 12 glxgears to see the effect of CFS v8 on my Athlon64 X2 
> 4200.
> 
> Without this patch all the GL load was handled by the second core, the 
> system only stressed the first core if other processes were also 
> started, i.e. a kernel compilation. With this patch the load is evenly 
> balanced across the two cores all the time.

ok, i didnt realize that it would affect x86_64 too. I'll do a -v9 
release with this fix included.

> [...] And while doing make -j4 on the kernel, the 12 gears are still 
> spinning about 185+ FPS and there are only slightly visible hiccups. 
> Switching between workspaces, i.e. refreshing the large windows of 
> Thunderbird and Firefox are done very quickly, the whole system is 
> exceptionally responsive.

great! So it seems -v8 does improve OpenGL handling too :-)

> Thanks for this great work!

you are welcome :)

	Ingo
