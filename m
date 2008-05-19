Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYESQj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYESQj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759513AbYESQjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:39:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51369 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759419AbYESQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:39:05 -0400
Date: Mon, 19 May 2008 09:39:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Mike Travis <travis@sgi.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
In-Reply-To: <200805171533.46295.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0805190938240.18382@schroedinger.engr.sgi.com>
References: <482C9FC5.2070508@cosmosbay.com> <482D1BCE.3060501@cosmosbay.com>
 <482D8EFC.8040109@sgi.com> <200805171533.46295.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Rusty Russell wrote:

> > > You mean using alloc_percpu() ? Problem is that current implementation
> > > is expensive,
> 
> I mean rewriting alloc_percpu :)

cpu_alooc is going to replace that completely.
> 
> > > We probably can change this to dynamic per-cpu as soon as Mike or
> > > Christopher finish their work on new dynamic per-cpu implementation ?
> >
> > Yes, the zero-based percpu variables followed by the cpu_alloc patch should
> > provide this and shrink the code quite well, including in some cases
> > removing locking requirements (because the resultant instructions will be
> > atomic.)
> 
> Ah, I hadn't realized that Mike was already working on this.  Mike, have you 
> published patches already?

He is reworking my patches. He can use some encouragement though...

