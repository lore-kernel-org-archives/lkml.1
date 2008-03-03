Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYCCL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYCCL5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYCCL5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:57:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60248 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYCCL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:57:06 -0500
Date: Mon, 3 Mar 2008 12:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: yi.y.yang@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080303115652.GA9257@elte.hu>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <b647ffbd0803030354s268089fo8e5b8f647ada0aae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0803030354s268089fo8e5b8f647ada0aae@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

>                 per_cpu(watchdog_task, hotcpu) = NULL;
> +               mlseep(1);

that wont build very well ...

	Ingo
