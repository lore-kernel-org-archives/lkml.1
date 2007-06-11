Return-Path: <linux-kernel-owner+w=401wt.eu-S1764322AbXFKH5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764322AbXFKH5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764239AbXFKH50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:57:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764228AbXFKH5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:57:25 -0400
Date: Mon, 11 Jun 2007 09:57:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Lee Revell <rlrevell@gmail.com>
Subject: Re: 2.6.21-rt9 - IRQ23 consuming a steady 2.7% of CPU
Message-ID: <20070611075722.GA9852@elte.hu>
References: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com> <20070610172452.GA7560@elte.hu> <5bdc1c8b0706101038q2f0e3418t1a595e749b5bfe71@mail.gmail.com> <20070610180745.GA14912@elte.hu> <5bdc1c8b0706101344o78d202dcx5cfdaea0fd73ddf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bdc1c8b0706101344o78d202dcx5cfdaea0fd73ddf7@mail.gmail.com>
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


* Mark Knecht <markknecht@gmail.com> wrote:

> Hi Ingo,
>   Yep, that solved it on my machine. I did have to patch using 'patch 
> -p1 -R' I think that's because the paths in your patch file are maybe 
> based on your work setup? I don't know. I'm amazed most of the time 
> that I can even do this stuff but with your help it seems to work out. 
> Thanks.
> 
>   Anyway, top no longer reports the 2.7% CPU usage from IRQ23. I do 
> see a little bit of CPU consumption from X and firefox but that seems 
> pretty reasonable.

ok, thanks - i took that change out from -rt.

	Ingo
