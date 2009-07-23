Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZGWAyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZGWAyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZGWAyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:54:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:58637 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZGWAyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:54:15 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
In-Reply-To: <alpine.LFD.2.01.0907220930320.19335@localhost.localdomain>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	 <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop>
	 <alpine.LFD.2.01.0907220930320.19335@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 10:53:35 +1000
Message-Id: <1248310415.3367.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 09:31 -0700, Linus Torvalds wrote:
> > CC'ing Linus here. How do you want to proceed with that merge ? (IE. so
> > far nobody objected to the patch itself)
> 
> Maybe you can put it as a separate branch in -next, and have it merged 
> before the stuff that depends on it, and then just sending it to me (as a 
> git branch or patch or whatever) in the first day of the merge window?

Hrm... my powerpc-next branch will contain stuff that depend on it, so
I'll probably have to pull it in though, unless I tell all my
sub-maintainers to also pull from that other branch first :-)

Cheers,
Ben.


