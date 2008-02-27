Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbYB0XdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbYB0XdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYB0Xcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:32:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46162 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbYB0Xcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:32:53 -0500
Date: Wed, 27 Feb 2008 15:32:52 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <20080219200852.GC11197@Krystal>
Message-ID: <Pine.LNX.4.64.0802271532220.14380@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
 <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
 <20080219200852.GC11197@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Mathieu Desnoyers wrote:

> incrementing the variable with a "++" when interrupts are not disabled.
> It's not an atomic add and it's racy. The code within stat() does
> exactly this.

Yes but that is only for used for statistics which can be racy. Note that 
the VM event statistics also can be racy.

