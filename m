Return-Path: <linux-kernel-owner+w=401wt.eu-S1030456AbXCFJfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456AbXCFJfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXCFJfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:35:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53232 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030456AbXCFJfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:35:21 -0500
Date: Tue, 6 Mar 2007 10:34:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
Message-ID: <20070306093436.GA30239@elte.hu>
References: <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED3121.8090308@suse.de>
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

> Oh, and btw: What was the reason why kvm paravirtualization doesn't 
> use the vmi interface?

cleanliness and performance: KVM doesnt need any artificial indirection. 
IMO the GPL-ed ROM portion of VMI was a bad idea to begin with. Also, 
lguest and KVM is Linux-internal, so there's a natural match between the 
guest and the host APIs.

> > yes, just like we have thousands of separate PC boards to support. 
> > But as long as the basic ABI is the same, the QA effort on the Linux 
> > kernel side is alot more focused.
> 
> xen and vmware are still two very different hypervisors from the 
> memory mangement point of view.  I doubt moving the abstraction line 
> within the linux kernel from paravirt_ops to vmi makes QA easier.

well, the VMI patches got into Linux with the claim that it's also 
useful for Xen. So that claim was ... not actually true?

	Ingo
