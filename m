Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXJKAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXJKAYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXJKAYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 20:24:07 -0400
Received: from ozlabs.org ([203.10.76.45]:50919 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXJKAYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 20:24:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18189.27936.484657.548537@cargo.ozlabs.ibm.com>
Date: Thu, 11 Oct 2007 10:24:00 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
       Olof Johansson <olof@lixom.net>, Greg KH <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Theodore Ts'o" <tytso@mit.edu>,
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
References: <20071008180406.052382073@mini.kroah.org>
	<20071008180633.GJ7627@kroah.com>
	<20071009151702.GA19209@lixom.net>
	<20071009222003.GA21228@kroah.com>
	<alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain>
	<alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> On Wed, 10 Oct 2007, Thomas Gleixner wrote:
> > 
> > Wrapping it into a #ifdef CONFIG_X86 would be sufficient.
> 
> Well, the ppc oops seems to be a ppc bug regardless.

Sure.  And Milton and Olof have figured out what the problem is and
proposed patches to fix it.

However, I'm a bit annoyed that a significant change in behaviour like
that, with a significant likelihood of causing regressions, went in so
late (after -rc8), in a manner that affects all SMP architectures, and
without being posted to linux-arch (unless I missed it).

Paul.
