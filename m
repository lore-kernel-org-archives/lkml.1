Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXIYVS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXIYVS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXIYVST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:18:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbXIYVSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:18:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: Disable local APIC timer use on AMD systems with C1E
Date: Tue, 25 Sep 2007 23:32:40 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
References: <1190749021.17409.35.camel@chaos> <200709252255.06039.rjw@sisk.pl> <1190753706.17409.64.camel@chaos>
In-Reply-To: <1190753706.17409.64.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709252332.41710.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 22:55, Thomas Gleixner wrote:
> On Tue, 2007-09-25 at 22:55 +0200, Rafael J. Wysocki wrote:
> > I have reworked the patch a bit so that it applies on top of 2.6.23-rc8-mm1
> > and compiles (my version is attached).
> > 
> > With this patch applied, the kernel boots correctly on the nx6325.
> 
> I know. It's basically enforced "noapictimer". 
> 
> But this still does not explain why your nasty box booted current
> mainline with "apicmaintimer" on the kernel command line.

Now it doesn't do that any more.

As I wrote in the other thread, I think that _sometimes_ the CPU doesn't enter
the C1E state (or how it's called) and then the box boots and works.

Greetings,
Rafael
