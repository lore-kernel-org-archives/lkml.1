Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbZANK1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbZANK1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZANK1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:27:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZANK1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:27:23 -0500
Date: Wed, 14 Jan 2009 11:27:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: add __cpuinit to rcu_init_percpu_data()
Message-ID: <20090114102703.GA25284@elte.hu>
References: <496D8D07.5080108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D8D07.5080108@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> Impact: rcu_init_percpu_data() is not use after boot when !CONFIG_HOTPLUG_CPU
> 
> add __cpuinit to rcu_init_percpu_data(), and this function's text
> will be discarded after boot when !CONFIG_HOTPLUG_CPU.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

applied to tip/core/urgent, thanks!

	Ingo
