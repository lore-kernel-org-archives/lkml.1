Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbZEYO6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbZEYO6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZEYO6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:58:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45671 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZEYO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:58:13 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       npiggin@suse.de
In-Reply-To: <1243263359.12761.48.camel@calx>
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
Date: Mon, 25 May 2009 17:58:13 +0300
Message-Id: <1243263493.2151.15.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 09:55 -0500, Matt Mackall wrote:
> > And oh, Christoph/Matt, can I have your NAK/ACK for this patch?
> 
> Looks ok to me, though I'd probably split it into three parts (slab,
> slub, init).

Yeah, the patch is pretty big but I don't think we can do that. It would
break git bisect.

			Pekka

