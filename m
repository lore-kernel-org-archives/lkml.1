Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbZE1MOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbZE1MOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZE1MO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:14:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46697 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZE1MO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:14:26 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux.com>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, npiggin@suse.de
In-Reply-To: <alpine.DEB.1.10.0905261318040.22176@gentwo.org>
References: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
	 <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
	 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
	 <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu>
	 <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu>
	 <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
	 <1243263359.12761.48.camel@calx>
	 <alpine.DEB.1.10.0905261318040.22176@gentwo.org>
Date: Thu, 28 May 2009 15:14:26 +0300
Message-Id: <1243512866.11533.53.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 13:19 -0400, Christoph Lameter wrote:
> Could we document the core boot strap procedure some more? I think we will
> have slight breakage in various parts if we change the order. If we had
> some design to guide then it may be easier to bring all the components in
> order.

Hmm. I am avoiding all the hard issues by letting all the architecture
specific early boot code run before I set up the kernel memory
allocators. The only thing that changes order is init_IRQ() which should
be fine.

			Pekka

