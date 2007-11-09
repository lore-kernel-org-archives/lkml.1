Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbXKIKcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbXKIKcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 05:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXKIKcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 05:32:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60495 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbXKIKcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 05:32:46 -0500
Date: Fri, 9 Nov 2007 11:25:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, sukadev@us.ibm.com,
       balbir@in.ibm.com, Containers <containers@lists.osdl.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, efault@gmx.de
Subject: Re: [BUG]: Crash with CONFIG_FAIR_CGROUP_SCHED=y
Message-ID: <20071109102523.GA10903@elte.hu>
References: <20071108234805.GA2240@us.ibm.com> <20071109070214.GO3143@linux.vnet.ibm.com> <b647ffbd0711090045o5ebf4681q78f939f5c1e71fe1@mail.gmail.com> <20071109101437.GA22544@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109101437.GA22544@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> With the patch below, I could run ns_exec() fine w/o a crash.
> 
> Suka, can you verify whether this patch fixes your problem?

thanks, applied. I'll wait for confirmation from Suka before sending it 
to Linus.

	Ingo
