Return-Path: <linux-kernel-owner+w=401wt.eu-S937241AbXGUIQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937241AbXGUIQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935486AbXGUIQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:16:04 -0400
Received: from www.osadl.org ([213.239.205.134]:41468 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935080AbXGUIQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:16:01 -0400
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, Steven Rostedt <rostedt@goodmis.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <200707210942.48444.ak@suse.de>
References: <1184970779.4012.38.camel@chaos> <200707210806.12880.ak@suse.de>
	 <20070721073533.GE3801@stusta.de>  <200707210942.48444.ak@suse.de>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 10:15:57 +0200
Message-Id: <1185005757.4012.102.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 09:42 +0200, Andi Kleen wrote:
> > 
> > It happens so often that someone accidentally breaks one architecture 
> > because he didn't notice the code also gets used on the other 
> > architecture.
> 
> That's not changing at all. Especially with even more sharing, (than I think
> would be prudent) like Thomas treated, you'll likely have to test compile both
> for most changes.

And a shared code base makes it entirely clear, that you must recheck
bot ARCHs when you touch code in there. 

Right now it is not clear at all.

	tglx


