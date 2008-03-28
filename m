Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYC1Tcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYC1Tcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYC1Tcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:32:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYC1Tce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:32:34 -0400
Date: Fri, 28 Mar 2008 12:32:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <Pine.LNX.4.64.0803281133190.17805@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.00.0803281231000.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl>  <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>  <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>  <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com> <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803281133190.17805@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Christoph Lameter wrote:
> 
> __GFP_ZERO is cleared in one place when new_slab() calls allocate_slab(). 

You're so full of crap that it's not even funny.

The fact that one path does it correct makes it ok to do it wrong in 
another path?

> The fallback code in 2.6.25 will go away in 2.6.26.

And the fact that 2.5.26 may fix it differently makes it ok to be buggy in 
2.6.25?

You are not making any sense what-so-ever.

		Linus
