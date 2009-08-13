Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZHMTsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZHMTsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZHMTsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:48:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619AbZHMTsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:19 -0400
Date: Thu, 13 Aug 2009 12:46:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: mano@roarinelk.homelinux.net, rjw@sisk.pl, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       akpm@linux-foundation.org, andrew.patterson@hp.com
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <200908132128.31439.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0908131244280.28882@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net>
 <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain> <20090805170934.GA32274@roarinelk.homelinux.net> <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain> <alpine.LFD.2.01.0908071116520.3390@localhost.localdomain>
 <20090811184740.49f52b57@scarran.roarinelk.net> <20090811184740.49f52b57@scarran.roarinelk.net> <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain> <200908132128.31439.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Aug 2009, Frans Pop wrote:
> 
> It's never resulted in things not working, but it would still be nice if
> it got solved. Please let me know if you'd like anything tested.

Did you test the trial-balloon patch I sent to Manuel? It's not the one 
I'd ever commit, but behavior-wise it's likely very close in practice to a 
patch that would iterate over possible parent resources (ie there are 
differences in theory but probably not so many in practice).

So testing it on your machine would be sensible. And you might also remind 
me after 2.6.31 is out.

		Linus
