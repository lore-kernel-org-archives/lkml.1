Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbXCNWGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbXCNWGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXCNWGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:06:12 -0400
Received: from ozlabs.org ([203.10.76.45]:44946 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbXCNWGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:06:11 -0400
Subject: Re: [RFC/PATCH 00/59] Make common x86 arch area for i386 and x86_64
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070314101223.GA88507@muc.de>
References: <1173820919.28042.3.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
	 <20070314101223.GA88507@muc.de>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 09:05:47 +1100
Message-Id: <1173909947.19022.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 11:12 +0100, Andi Kleen wrote:
> On Tue, Mar 13, 2007 at 02:39:33PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 13 Mar 2007, Steven Rostedt wrote:
> > > 
> > > What we have currently is a bunch of hacks.  Seems that people can't make
> > > up their mind to what to do.
> 
> I think they work fine.

My first instinct was to agree with Andi, or maybe have a "shared"
directory a-la x86/.  But I had a fruitful discussion with the PowerPC
people, who went through (and are still completing) the transition to
one directory.

Their verdict, surprisingly, was definitely positive.  They started with
a single powerpc dir which simply included ppc64/ or ppc/, then pulled
parts into that directory until ppc64/ was gone.  The things left in
ppc/ are being slowly merged, and some may be dropped entirely.

They can obviously speak for themselves, but the cleanup caused by the
movement was seen as a net win.

Rusty.


