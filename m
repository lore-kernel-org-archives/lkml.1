Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXJYXz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXJYXz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXJYXzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:55:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:37994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXJYXzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:55:50 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 01:55:46 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260109.50092.ak@novell.com> <200710260943.44719.nickpiggin@yahoo.com.au>
In-Reply-To: <200710260943.44719.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260155.46339.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But we don't actually know what it is, and it could change with
> different architectures or versions of gcc. I think the sanest thing
> is for gcc to help us out here, seeing as there is this very well
> defined requirement that we want.
> 
> If you really still want the optimisation to occur, 

I don't think it makes sense for memory. It may may make sense for registers.

But given that my kernel doesn't seem to contain any instances
at all it's probably not too useful for it anyways.

So I wouldn't have a problem disabling it, but it would
be better if they fixed their heuristics to only apply it when
it makes sense. 

Unfortunately it's not possible as far as I know with current gccs.
I didn't think you can disable only ADC/SBB.

Disabling all of CMOV would be a pity though. Also I don't think
there is any way to do that except selecting a CPU architecture
that doesn't support it which would have other bad side effects
on the code.

-Andi
