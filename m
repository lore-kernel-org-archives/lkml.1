Return-Path: <linux-kernel-owner+w=401wt.eu-S1161061AbXBRCfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161061AbXBRCfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161066AbXBRCfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:35:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161061AbXBRCfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:35:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@openvz.org>
X-Fcc: ~/Mail/utrace
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: utrace regressions (was: -mm merge plans for 2.6.21)
In-Reply-To: Alexey Dobriyan's message of  Tuesday, 13 February 2007 18:35:21 +0300 <20070213153521.GA6036@localhost.sw.ru>
X-Shopping-List: (1) Parliamentary honk watchers
   (2) Paradoxical reinforcement tensions
   (3) Psychotic studious money bags
Message-Id: <20070218023531.626D11800E4@magilla.sf.frob.com>
Date: Sat, 17 Feb 2007 18:35:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking at mainline x86_64 ptrace code I think hole for u_debugreg[4]
> and [5] is also needed.

It's not.  The utrace_regset for the debugregs already has that behavior
for those two words, so mapping all 8 uarea words to the regset is fine.


Thanks,
Roland
