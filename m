Return-Path: <linux-kernel-owner+w=401wt.eu-S1764109AbXGTSfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764109AbXGTSfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXGTSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:34:51 -0400
Received: from khc.piap.pl ([195.187.100.11]:41735 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbXGTSeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:34:50 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
References: <20070718235504.GA9601@havoc.gtf.org>
	<alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
	<469ECD29.2010909@garzik.org> <m3r6n4bjgg.fsf@maximus.localdomain>
	<alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 20 Jul 2007 20:34:46 +0200
In-Reply-To: <alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org> (Linus Torvalds's message of "Thu, 19 Jul 2007 11:04:29 -0700 (PDT)")
Message-ID: <m3644e2abd.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> More people *should* generally ask themselves: "was the warning worth it?" 
> and then, if the answer is "no", they shouldn't add code, they should 
> remove the thing that causes the warning in the first place.

Sure. If a routine uses must_check yet its return value may be
safely ignored then that must_check is simply misplaced and should
be removed. It does not mean all must_checks are bad - each of them
isn't bad unless one can demonstrate it is.

Back to sysfs_create_bin_file() - if one can demonstrate a caller
can safely ignore the return value (which, it seems, is the
case), then exactly this very must_check should be removed.
-- 
Krzysztof Halasa
