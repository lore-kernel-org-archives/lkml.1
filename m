Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYIAR5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYIAR5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYIAR4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:56:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbYIAR4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:56:52 -0400
Date: Mon, 1 Sep 2008 10:56:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Will Newton" <will.newton@gmail.com>
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       alex.williamson@hp.com
Subject: Re: [PATCH] serial 8250: tighten test for using backup timer
Message-Id: <20080901105641.4f4d9509.akpm@linux-foundation.org>
In-Reply-To: <87a5b0800809010636m227bce15y59d8bb988a601802@mail.gmail.com>
References: <200808261045.34699.david-b@pacbell.net>
	<20080826105845.6ddf1107.akpm@linux-foundation.org>
	<87a5b0800809010636m227bce15y59d8bb988a601802@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 14:36:56 +0100 "Will Newton" <will.newton@gmail.com> wrote:

> On Tue, Aug 26, 2008 at 6:58 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 26 Aug 2008 10:45:34 -0700
> > David Brownell <david-b@pacbell.net> wrote:
> >
> >> > > Also, how serious is the problem which is being fixed here?  It
> >> > > _sounds_ like it's of the "fatal for people who have that hardware"
> >> > > variety, in which case we should get this into 2.6.27 and probably
> >> > > 2.6.26.x.  Not sure about 2.5.26.x though - the patch doesn't apply
> >> > > there, but I didn't check whether this is due to functional changes.
> >> >
> >> > For users of this version of this particular UART IP it is fatal. From
> >> > looking at the git history it looks like the original patch went into
> >> > 2.6.26 so it might also affect that kernel.
> >>
> >> Second that:  serial-8250-tighten-test-for-using-backup-timer.patch
> >> (from MMOTM) in mainline sooner-not-later seems right.
> >
> > ok, if you think so...
> >
> > I still have an unanswered question out there about the init_timer()
> > handling in that area of the driver but afaict this patch didn't make any
> > of it worse than it already is.
> 
> Any update on this situation? I'd really like this patch to get into 2.6.27.

yup, I plan to include the patch in my next batch for 2.6.27.
