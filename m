Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZBRAyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZBRAyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZBRAyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:54:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58871 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbZBRAyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:54:16 -0500
Date: Wed, 18 Feb 2009 01:54:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH] sysrq: add extension char/table handling
Message-ID: <20090218005402.GI25856@elte.hu>
References: <4999CDCF.9040908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4999CDCF.9040908@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Hi, [repeat from April-2008]
> 
> Ingo noticed that the sysrq table is close to filling up.
> [It's full now, counting the optional & proposed/new entries.]
> Has anyone thought about how to handle that condition?
> 
> Here's one patch for it, although I'm not entirely thrilled with it.
> Any other suggestions?

Another option would be to make Shift-SysRq the extension. That 
way there's a difference between: SysRq-t and SysRq-T. (the 
former is the usual key, the latter is the extended one.)

	Ingo
