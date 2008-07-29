Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYG3BhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYG3BhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYG3Bg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:36:58 -0400
Received: from ozlabs.org ([203.10.76.45]:49267 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbYG3Bg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:36:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Introduce down_try() so we can move away from down_trylock()
Date: Wed, 30 Jul 2008 09:56:53 +1000
User-Agent: KMail/1.9.9
Cc: "Paul Menage" <menage@google.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <200807292301.18733.rusty@rustcorp.com.au> <20080729092102.14e6d964.rdunlap@xenotime.net>
In-Reply-To: <20080729092102.14e6d964.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807300956.55445.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 02:21:02 Randy Dunlap wrote:
> On Tue, 29 Jul 2008 23:01:17 +1000 Rusty Russell wrote:
> > Andrew suggested introducing "down_try" as a wrapper now, to make
> > the transition easier.
>
> Hi Rusty,
>
> Will you also be making updates to
> Documentation/DocBook/kernel-locking.tmpl ?

Hi Randy,

   The section on sems has been removed in the latest Linus tree.  We're 
trying to bury semaphores, but it's not clear that will ever happen; hence 
this bet-hedging patch.

Cheers,
Rusty.
