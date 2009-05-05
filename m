Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZEEXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZEEXLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZEEXLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:11:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35508 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZEEXLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:11:43 -0400
Date: Wed, 6 May 2009 01:06:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090505230642.GA980@redhat.com>
References: <20090503185537.GA17071@redhat.com> <20090504184951.623CEFC32F@magilla.sf.frob.com> <20090504193016.GA17076@redhat.com> <20090504194348.BC0EBFC32F@magilla.sf.frob.com> <20090504163154.f3672a83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504163154.f3672a83.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04, Andrew Morton wrote:
>
> On Mon,  4 May 2009 12:43:48 -0700 (PDT)
> Roland McGrath <roland@redhat.com> wrote:
>
> > I guess we should take Andrew's advice on this.  To me, it makes most sense
> > just to order the -mm patches so utrace comes later, and replace the utrace
> > patch as necessary with a compatible version.  Perhaps things would be
> > simpler if we made a separate standalone series or git tree (tip/ptrace?)
> > for ptrace cleanups.
>
> Staging the utrace patch at end-of-series would make sense if utrace is
> not on track for a 2.6.31 merge.
>
> And afaict, this is indeed the case - things seem to have gone a bit
> quiet on the utrace front lately.

The only goal of current ptrace cleanups is to simplify the "ptrace over
utrace" change (hopefully they make sense by themselves though).

I am obviously biased, but imho the only real problem with utrace-ptrace.patch
is the current ptrace code which needs cleanups.

Oleg.

