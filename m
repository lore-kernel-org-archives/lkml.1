Return-Path: <linux-kernel-owner+w=401wt.eu-S1765661AbXLTOkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765661AbXLTOkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXLTOd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:33:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbXLTOd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:33:26 -0500
Date: Thu, 20 Dec 2007 15:32:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [patch 1/5] x86, ptrace: rlimit BTS buffer allocation
Message-ID: <20071220143259.GA21803@elte.hu>
References: <20071220140530.A29536@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220140530.A29536@sedona.ch.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Check the rlimit of the tracing task for total and locked memory when 
> allocating the BTS buffer.

thanks, i've picked up your patches into x86.git. I suspect if/once 
Roland has any objections on the API we'd have to resolve those - but to 
me it looks quite usable at the moment.

	Ingo
