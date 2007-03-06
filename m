Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbXCFKb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbXCFKb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbXCFKb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:31:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49669 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934013AbXCFKbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:31:55 -0500
Date: Tue, 6 Mar 2007 11:31:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: Avi Kivity <avi@argo.co.il>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
Message-ID: <20070306103137.GB7478@elte.hu>
References: <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <45ED3A8D.9090906@argo.co.il> <45ED4117.40701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED4117.40701@suse.de>
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


* Gerd Hoffmann <kraxel@suse.de> wrote:

> Thanks.  That is actually the point I want make: although it is 
> *possible* to do that via VMI ROM, doing that using paravirt_ops is 
> *better* (no matter whenever the hypervisor is xen or kvm). [...]

but paravirt_ops is not an ABI ... nor will it ever become one. So the 
fact remains: the extra ABIs towards external hypervisors are quite an 
issue.

> [...] The very same discussion a couple months ago came to exactly 
> that conclusion.

uhm, that discussion mostly only involved people interested in external 
hypervisors, not those poor souls who have to fix up the mess in the end 
within Linux ;-) [ I am very sure all foxes would come to the happy 
conclusion that there is no need for any stinkin' lock on the barn ;-) ]

	Ingo
