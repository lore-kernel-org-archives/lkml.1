Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbXJ2LlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbXJ2LlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 07:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXJ2LlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 07:41:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbXJ2LlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 07:41:14 -0400
Date: Mon, 29 Oct 2007 12:40:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, wfg@mail.ustc.edu.cn,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: 2.6.24-rc1: First impressions
Message-ID: <20071029114048.GA22599@elte.hu>
References: <213736.67377.qm@web32614.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <213736.67377.qm@web32614.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2111]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Knoblauch <knobi@knobisoft.de> wrote:

>  One of the reasons I do 15 GB transfers is to make sure that I am 
>  well above the possible page cache size. And of course I am doing a 
>  final sync to finish the runs :-) The sync is also running faster in 
>  2.6.24-rc1.
> 
>  If I factor it in the results for dd1/dd3 are:
> 
> test                2.6.19.2        2.6.22.6    2.6.24-rc1
> sync time              18sec           19sec          6sec
> dd1                     27.5            47.5            92
> dd3                    3x9.1           3x8.5          3x29
> 
> So basically including the sync time make 2.6.24-rc1 even more 
> promosing. Now, I know that my benchmarks numbers are crude and show 
> only a very small aspect of system performance. But - it is an aspect 
> I care about a lot. And those benchmarks match my use-case pretty 
> good.

indeed. I'm even more impressed :)

	Ingo
