Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYIEKv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYIEKv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYIEKvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:51:18 -0400
Received: from r00tworld.com ([212.85.137.21]:59913 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYIEKvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:51:17 -0400
X-Greylist: delayed 2377 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 06:51:17 EDT
From: pageexec@freemail.hu
To: benh@kernel.crashing.org
Date: Fri, 05 Sep 2008 12:49:41 +0200
MIME-Version: 1.0
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Reply-to: pageexec@freemail.hu
CC: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       hpa@zytor.com
Message-ID: <48C10EC5.24400.3008276@pageexec.freemail.hu>
In-reply-to: <1220609647.4879.169.camel@pasglop>
References: <20080903195122.73905236@infradead.org>, <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>, <1220609647.4879.169.camel@pasglop>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Fri, 05 Sep 2008 12:50:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Sep 2008 at 20:14, Benjamin Herrenschmidt wrote:

> On Fri, 2008-09-05 at 11:43 +0200, pageexec@freemail.hu wrote:
> > > I'd have considered taking your email serious if you had left out the
> > > uncalled and unneeded sarcasm line at the end.
> > 
> > consider how your whole patch is based on one big self-contradiction.
> > you already assume that the attacker *can* modify arbitrary kernel memory
> > (even the otherwise *read-only* syscall table at that), but at the very
> > same time you're saying he *can't* use the same powers to patch out your
> > 'protection' or do many other things to evade it. as it is, it's cargo cult
> > security at its best, reminding one on the Vista kernel's similar 'protection' 
> > mechanism for the service descriptor tables...
> 
> Well, I see it a different way ... it will once for all screw up
> binary modules that try to add syscalls :-)

and that'd be because at the same time they patch the syscall table (remember,
they already have to go to length to get around the read-only pages), they
can't also patch this 'protection'? sounds really plausible, right :).

[fixed hpa's address, .org bounces.]

