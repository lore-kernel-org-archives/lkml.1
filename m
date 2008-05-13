Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYEMLN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYEMLN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYEMLNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:13:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58269 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbYEMLNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:13:19 -0400
Date: Tue, 13 May 2008 13:13:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: use set_memory_4k() instead of disabling PSE
Message-ID: <20080513111307.GB1679@elte.hu>
References: <20080510153307.GA28901@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510153307.GA28901@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> With this, we reduce the overall impact of kmemcheck by reverting some 
> earlier, now unnecessary, changes:

> Thanks a bunch to Andi Kleen for this brilliant solution. Now all 
> pages that kmemcheck handle will be 4k in size, and we need no 
> special-case code to handle larger pages.

applied, thanks guys.

	Ingo
