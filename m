Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXGKSCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXGKSCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766001AbXGKSCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:02:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760810AbXGKSCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:02:33 -0400
Date: Wed, 11 Jul 2007 11:01:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Orr <martin@martinorr.name>
cc: Andi Kleen <andi@firstfloor.org>, Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: <46951892.20406@martinorr.name>
Message-ID: <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
 <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
 <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de>
 <46951892.20406@martinorr.name>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Martin Orr wrote:
> 
> I have done this.  The file is arch/x86_64/kernel/signal.c: if I compile
> this with gcc 20070627 then everything works, if I compile it with gcc
> 20070707 then udevsettle hangs.  This is independent of the gcc version used
> to compile the rest of the kernel.  (The dates refer to versions of the
> Debian gcc-4.2 package and its dependencies.)

Can you do

	make arch/x86_64/kernel/signal.s

with both compilers, and post the results somewhere? It's probably going 
to be so large, and have so many trivial differences (register allocation 
etc) that it will be hard-to-impossible to see the problem, but at least 
we can *try* to see if it might be obvious enough from comparing the 
assembly..

(Register allocation differences make comparisons like that really hard, 
but if the two compiler versions are close enough, they *might* end up 
having sufficiently similar register allocation that the stupid 
differences don't hide all the real differences).

			Linus
