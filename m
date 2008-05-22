Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYEVPs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYEVPs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYEVPsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:48:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:22497 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYEVPst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:48:49 -0400
Subject: Re: [PATCH] Introduce down_nowait()
From: Daniel Walker <dwalker@mvista.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <200805221856.23824.rusty@rustcorp.com.au>
References: <200805211600.16415.rusty@rustcorp.com.au>
	 <200805211756.04731.rusty@rustcorp.com.au>
	 <1211389499.18130.53.camel@localhost.localdomain>
	 <200805221856.23824.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Thu, 22 May 2008 08:48:43 -0700
Message-Id: <1211471323.18130.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 18:56 +1000, Rusty Russell wrote:

> The patches to change down_trylock to down_try touch a heap of files, which 
> are also touched in other people's trees.  If this patch goes upstream, those 
> people rewriting that code can use down_try in their rewrite, and I can throw 
> mine away.

Seems like it's too much trouble.. I mean, we're removing semaphores
anyway and down_trylock with them. I'll agree with Andrew down_trylock
removal is pretty glacial. It's cause there aren't many of them and most
of the ones I've looked at are in strange locking schemes, which makes
them difficult to remove.. 

I'm not against your changes, but if it's going to cause problems I'd
rather people focus on mutex_trylock instead.

Daniel

