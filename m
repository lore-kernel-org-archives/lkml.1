Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXCKMLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXCKMLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbXCKMLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:11:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50449 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbXCKMLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:11:35 -0400
Date: Sun, 11 Mar 2007 13:10:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070311121038.GA9146@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <1173613149.6927.29.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173613149.6927.29.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > Full patch for 2.6.21-rc3-mm2: 
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.29.patch
> 
> I'm seeing a cpu distribution problem running this on my P4 box.

> With 2.6.21-rc3, X/Gforce maintain their ~50% cpu (remain smooth), and 
> the encoders (100%cpu bound) get whats left when Amarok isn't eating 
> it.
> 
> I plunked the above patch into plain 2.6.21-rc3 and retested to 
> eliminate other mm tree differences, and it's repeatable.  The nice 5 
> cpu hogs always receive considerably more that the nice 0 sleepers.

hm. Do you get the same same problem on UP too? (i.e. lets eliminate any 
SMP/HT artifacts)

	Ingo
