Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZEDXf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZEDXf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbZEDXfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:35:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbZEDXfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:35:10 -0400
Date: Mon, 4 May 2009 16:31:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jdike@addtoit.com, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-Id: <20090504163154.f3672a83.akpm@linux-foundation.org>
In-Reply-To: <20090504194348.BC0EBFC32F@magilla.sf.frob.com>
References: <20090503185537.GA17071@redhat.com>
	<20090504184951.623CEFC32F@magilla.sf.frob.com>
	<20090504193016.GA17076@redhat.com>
	<20090504194348.BC0EBFC32F@magilla.sf.frob.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 May 2009 12:43:48 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> > > When those are on their way,
> > > we'll update the utrace patches not to conflict.  I don't think it makes
> > > sense to include utrace.patch's little ptrace.c change in the baseline tree
> > > for your ptrace cleanup patches.
> > 
> > Yes, but in this case, how can we push it before utrace-core.patch ?
> > 
> > The first patch is only for -mm, to avoid the painful dependencies.
> 
> I guess we should take Andrew's advice on this.  To me, it makes most sense
> just to order the -mm patches so utrace comes later, and replace the utrace
> patch as necessary with a compatible version.  Perhaps things would be
> simpler if we made a separate standalone series or git tree (tip/ptrace?)
> for ptrace cleanups.

Staging the utrace patch at end-of-series would make sense if utrace is
not on track for a 2.6.31 merge.

And afaict, this is indeed the case - things seem to have gone a bit
quiet on the utrace front lately.

