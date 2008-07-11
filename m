Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYGKG7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYGKG7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 02:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYGKG7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 02:59:39 -0400
Received: from ozlabs.org ([203.10.76.45]:38523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbYGKG7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 02:59:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Date: Fri, 11 Jul 2008 16:59:19 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <48766967.7040008@goop.org> <m1fxqhtroj.fsf@frodo.ebiederm.org>
In-Reply-To: <m1fxqhtroj.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111659.19704.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 06:22:52 Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > No, that sounds like a bad idea.  For one, how would you enforce it?  How
> > would you check for it?  It's one of those things that would mostly work
> > and then fail very rarely.
>
> Well the easiest way would be to avoid the letting people take the address
> of per cpu memory, and just provide macros to read/write it.  We are 90% of
> the way there already so it isn't a big jump.

Hi Eric,

    I decided against that originally, but we can revisit that decision.  But 
it would *not* be easy.  Try it on kernel/sched.c which uses per-cpu "struct 
rq".

Perhaps we could limit dynamically allocated per-cpu mem this way though...

Rusty.
