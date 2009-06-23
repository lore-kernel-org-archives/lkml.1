Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZFWTPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZFWTPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZFWTPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:15:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47573 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZFWTPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:15:04 -0400
Date: Tue, 23 Jun 2009 21:14:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "mark.langsdorf@amd.com" <mark.langsdorf@amd.com>
Subject: Re: [PATCH] cpufreq: remove dbs_mutex
Message-ID: <20090623191418.GA14455@elte.hu>
References: <4A2835D8.6040903@kernel.org> <20090611105211.GA6760@elte.hu> <20090620124817.GA22831@elte.hu> <200906212155.49849.trenn@suse.de> <20090623181748.GA31148@elte.hu> <20090623184040.GA6908@elte.hu> <1245783116.4534.17466.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245783116.4534.17466.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> Mathieu Desnoyers sent a patch earlier that should address this problem.
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/00331.html

No, that patch has _not_ fixed the regression:

  http://lkml.org/lkml/2009/6/8/563

	Ingo
