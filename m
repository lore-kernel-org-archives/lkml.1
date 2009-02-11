Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZBKPu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZBKPu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZBKPuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:50:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49462 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZBKPuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:50:16 -0500
Date: Wed, 11 Feb 2009 16:49:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -v3] futex: fix reference leak
Message-ID: <20090211154952.GB24408@elte.hu>
References: <1234190649.16083.44.camel@pc1117.cambridge.arm.com> <1234192363.5951.129.camel@laptop> <1234197950.5951.132.camel@laptop> <1234198023.5951.133.camel@laptop> <1234200538.16083.52.camel@pc1117.cambridge.arm.com> <1234203975.5951.143.camel@laptop> <1234205595.4286.223.camel@localhost.localdomain> <1234205874.5951.151.camel@laptop> <20090211122849.GD16535@elte.hu> <1234366605.23438.179.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234366605.23438.179.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> So you prefer this version?

yes, with s/out_unlock_put_key/err_unlock_put_key. That's the
only error path that goes via the tail of the function, correct?

	Ingo
