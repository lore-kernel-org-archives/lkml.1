Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZFYT4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZFYT4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbZFYT4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:56:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41515 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbZFYT4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:56:24 -0400
Date: Thu, 25 Jun 2009 21:55:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, jaswinderrajput@gmail.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] perf_counter tools: Shorten names
	for events
Message-ID: <20090625195542.GA18598@elte.hu>
References: <1245934522.5308.39.camel@hpdv5.satnam> <tip-e5c59547791f171b280bc4c4b2c3ff171824c1a3@git.kernel.org> <1245945462.9157.11.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245945462.9157.11.camel@hpdv5.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> - { "L1-d$",	"l1-d",		"L1-data",				},
> - { "L1-i$",	"l1-i",		"L1-instruction",			},
> + { "L1-d$",	"l1-d",		"l1d",		"L1-data",		},
> + { "L1-i$",	"l1-i",		"l1i",		"L1-instruction",	},

Yes, those aliases still make sense indeed, as long as they are not 
the primary alias (which is being displayed).

	Ingo
