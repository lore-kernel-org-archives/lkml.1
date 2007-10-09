Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXJIXgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXJIXgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXJIXgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:36:39 -0400
Received: from www.tglx.de ([62.245.132.106]:57592 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbXJIXgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:36:38 -0400
Date: Wed, 10 Oct 2007 01:35:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
       Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 09/12] Fix SMP poweroff hangs
In-Reply-To: <alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.99.0710100133590.5040@localhost.localdomain>
References: <20071008180406.052382073@mini.kroah.org> <20071008180633.GJ7627@kroah.com>
 <20071009151702.GA19209@lixom.net> <20071009222003.GA21228@kroah.com>
 <alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain>
 <alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 10 Oct 2007, Thomas Gleixner wrote:
> > 
> > Wrapping it into a #ifdef CONFIG_X86 would be sufficient.
> 
> Well, the ppc oops seems to be a ppc bug regardless.
> 
> If CPU_HOTPLUG isn't defined, the thing does nothing. And if it is 
> defined, I don't see why/how ppc can validly oops. So I think the first 
> thing to do is to try to figure out why it oopses, not to disable it for 
> ppc.

Fair enough. OTOH for the affected PPC users it's a regression and that's 
what I'm concerned of.

	tglx


