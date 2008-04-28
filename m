Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYD2Rtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYD2Rtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYD2Rt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:49:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42135 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYD2Rt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:49:26 -0400
Date: Mon, 28 Apr 2008 12:48:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2/2] vmallocinfo: Add caller information
Message-ID: <20080428124849.4959c419@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com>
	<20080318222827.519656153@sgi.com>
	<20080429084854.GA14913@elte.hu>
	<Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 10:08:29 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 29 Apr 2008, Ingo Molnar wrote:
> 
> > i pointed out how it should be done _much cleaner_ (and much
> > smaller - only a single patch needed) via stack-trace, without
> > changing a dozen architectures, and even gave a patch to make it
> > all easier for you:
> > 
> >     http://lkml.org/lkml/2008/3/19/568
> >     http://lkml.org/lkml/2008/3/21/88
> > 
> > in fact, a stacktrace printout is much more informative as well to 
> > users, than a punny __builtin_return_address(0)!
> 
> Sorry lost track of this issue. Adding stracktrace support is not a 
> trivial thing and will change the basic handling of vmallocinfo.
> 
> Not sure if stacktrace support can be enabled without a penalty on
> various platforms. Doesnt this require stackframes to be formatted in
> a certain way?

it doesn't.
