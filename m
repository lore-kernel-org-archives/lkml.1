Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbYEQFeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbYEQFeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 01:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYEQFeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 01:34:00 -0400
Received: from ozlabs.org ([203.10.76.45]:54737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYEQFd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 01:33:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
Date: Sat, 17 May 2008 15:33:46 +1000
User-Agent: KMail/1.9.9
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
References: <482C9FC5.2070508@cosmosbay.com> <482D1BCE.3060501@cosmosbay.com> <482D8EFC.8040109@sgi.com>
In-Reply-To: <482D8EFC.8040109@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805171533.46295.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008 23:41:16 Mike Travis wrote:
> Eric Dumazet wrote:
> > Rusty Russell a écrit :
> >>    Any chance I can ask you look at the issue of full dynamic per-cpu
> >> allocation?
> >
> > You mean using alloc_percpu() ? Problem is that current implementation
> > is expensive,

I mean rewriting alloc_percpu :)

> > We probably can change this to dynamic per-cpu as soon as Mike or
> > Christopher finish their work on new dynamic per-cpu implementation ?
>
> Yes, the zero-based percpu variables followed by the cpu_alloc patch should
> provide this and shrink the code quite well, including in some cases
> removing locking requirements (because the resultant instructions will be
> atomic.)

Ah, I hadn't realized that Mike was already working on this.  Mike, have you 
published patches already?

Thanks,
Rusty.
