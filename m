Return-Path: <linux-kernel-owner+w=401wt.eu-S934097AbXGKWQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbXGKWQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763053AbXGKWQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:16:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44055 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761799AbXGKWQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:16:28 -0400
Date: Thu, 12 Jul 2007 00:16:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Orr <martin@martinorr.name>, Andi Kleen <andi@firstfloor.org>,
       Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070711221626.GA25510@one.firstfloor.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de> <46951892.20406@martinorr.name> <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org> <469544D3.90004@martinorr.name> <alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think this is worth even trying to fix. This is terminal compiler 
> breakage. Make a bug-report to the gcc people, the inline asm stuff has 
> been totally buggered by that compiler version.
> 
> If it mis-compiled that part, it probably miscompiled a lot of other 
> things too.

I just checked with today's gcc 4.2 (070711) freshly compiled and from a quick inspection 
the code looks correct again. So perhaps it has been already fixed? 

http://firstfloor.org/~andi/signal.s-070711

Result also boots 

Unfortunately the date is not checkable in gcc so we can't easily add #errors.

-Andi
