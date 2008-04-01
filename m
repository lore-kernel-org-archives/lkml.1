Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYDAHmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYDAHmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYDAHmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:42:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:39473 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYDAHma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:42:30 -0400
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Martin Michlmayr <tbm@cyrius.com>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de>
References: <20080321153952.GA26354@deprecation.cyrius.com>
	 <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de>
	 <20080330161339.GC28821@deprecation.cyrius.com>
	 <47EFD09D.3020906@s5r6.in-berlin.de>
	 <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 18:41:13 +1100
Message-Id: <1207035673.10388.210.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-30 at 22:10 +0200, Thomas Gleixner wrote:
> > I tend to believe it is a problem to be addressed in the x86
> platform support,
> > not a driver problem.
> 
> Depends. It might be unfixable.

We had a similar bogus interrupt issue on GSI 19 with 965gm chipset on
thinkpads recently that ended up being a BIOS issue misconfiguring
something deep inside the chipset. We never knew what exactly, except
that BIOS updates fixed it. Could be something similar.

Ben.


