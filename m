Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbXCPJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbXCPJ0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932706AbXCPJ0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:26:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47449 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641AbXCPJ0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:26:45 -0400
Date: Fri, 16 Mar 2007 10:26:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 12/26] Xen-paravirt_ops: Fix patch site clobbers to include return register
Message-ID: <20070316092626.GN23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232527.755495278@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232527.755495278@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Fix a few clobbers to include the return register.  The clobbers set 
> is the set of all registers modified (or may be modified) by the code 
> snippet, regardless of whether it was deliberate or accidental.

i guess we need these paravirt.h clobber fixes for v2.6.21 (VMI) too, 
correct?

	Ingo
