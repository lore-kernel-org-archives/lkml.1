Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXJJFcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXJJFcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 01:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXJJFcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 01:32:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbXJJFcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 01:32:16 -0400
Date: Tue, 9 Oct 2007 22:29:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
       Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, Kevin <spaceman__spiff@cox.net>
Subject: Re: [stable] [patch 09/12] Fix SMP poweroff hangs
In-Reply-To: <alpine.LFD.0.99.0710100133590.5040@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0710092224000.3838@woody.linux-foundation.org>
References: <20071008180406.052382073@mini.kroah.org> <20071008180633.GJ7627@kroah.com>
 <20071009151702.GA19209@lixom.net> <20071009222003.GA21228@kroah.com>
 <alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain>
 <alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org>
 <alpine.LFD.0.99.0710100133590.5040@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Oct 2007, Thomas Gleixner wrote:
> 
> Fair enough. OTOH for the affected PPC users it's a regression and that's 
> what I'm concerned of.

Hmm.. I just got the appended (Kevin, better not just send me email, other 
people can be interested too):

From: Kevin <spaceman__spiff@cox.net>:
Subject: Segmentation Fault
> 
> I just installed Linux Kernel 2.6.23 and am getting a Segmentation Fault 
> upon exit (init 0).
> 
> Code: Bad EIP Value
> EIP: [<00007825>] 0x7825 SS:ESP 0068:e7305de8
> /etc/rc.d/rc.0: Line 261: 2796 Segmentation Fault   /sbin/poweroff
> 
> I'm running Slackware 12.0

and while there's not a lot of information there, it might still mean that 
there may be some issues on x86 too at the shutdown path.

Kevin: can you get the rest of the message? The kernel should have printed 
out much more than just those two lines (there should have been a stack 
trace and register state (often most easily captured simply with a digital 
camera)

			Linus
