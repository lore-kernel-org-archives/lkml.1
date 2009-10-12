Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZJLLQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZJLLQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZJLLQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:16:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZJLLQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:16:40 -0400
Date: Mon, 12 Oct 2009 13:15:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012111545.GB8857@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
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


* Artem Bityutskiy <dedekind1@gmail.com> wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> We use the mtdoops module which stores oopses on the Flash partition,
> in order to make it possible to analyze them later. And mtdoops needs
> to know whether 'panic_on_oops' is on or off. Thus, we need this
> variable to be exported.

hm, why does it need it? Could you send the patch please that makes use 
of it (as an easy way to explain the need for the export) - current 
upstream drivers/mtd/mtdoops.c doesnt need it so it must be some pending 
change.

	Ingo
