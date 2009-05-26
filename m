Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZEZRTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZEZRTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZEZRTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:19:41 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:44787 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753466AbZEZRTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:19:41 -0400
Date: Tue, 26 May 2009 13:19:08 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Matt Mackall <mpm@selenic.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, npiggin@suse.de
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <1243263359.12761.48.camel@calx>
Message-ID: <alpine.DEB.1.10.0905261318040.22176@gentwo.org>
References: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>  <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>  <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>  <20090518202031.GA26549@elte.hu> 
 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>  <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>  <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu>  <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu> 
 <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <1243263359.12761.48.camel@calx>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009, Matt Mackall wrote:

> > And oh, Christoph/Matt, can I have your NAK/ACK for this patch?
>
> Looks ok to me, though I'd probably split it into three parts (slab,
> slub, init).

Could we document the core boot strap procedure some more? I think we will
have slight breakage in various parts if we change the order. If we had
some design to guide then it may be easier to bring all the components in
order.
