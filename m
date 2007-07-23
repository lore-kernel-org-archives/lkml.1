Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXGWM2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXGWM2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXGWM2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:28:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXGWM2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:28:22 -0400
Date: Mon, 23 Jul 2007 14:28:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ni@m" <niam.niam@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sound is interrupting with new kernels
Message-ID: <20070723122813.GA9420@elte.hu>
References: <a9e22dff0707211510o3b5e108dk354f5f15ad3ba498@mail.gmail.com> <6bffcb0e0707221716k67815a2ai7f35606b1effa6a3@mail.gmail.com> <a9e22dff0707222125i49adade7seea63f12672aa701@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9e22dff0707222125i49adade7seea63f12672aa701@mail.gmail.com>
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


could you try CONFIG_HZ_1000 instead of the 250 you are using currently? 
Also, please enable CONFIG_SCHED_DEBUG to improve the output of 
cfs-debug-info.sh.

	Ingo
