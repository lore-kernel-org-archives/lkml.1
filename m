Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYKEQ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYKEQ2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYKEQ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:28:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbYKEQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:28:23 -0500
Date: Wed, 5 Nov 2008 08:27:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com
Subject: Re: Git next: Second stage of cpu_alloc patches
Message-Id: <20081105082754.2d41f0d1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811050753120.11867@quilx.com>
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
	<20081104195205.fe1bf62b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811050753120.11867@quilx.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 07:54:39 -0600 (CST) Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 4 Nov 2008, Andrew Morton wrote:
> 
> > On Tue, 4 Nov 2008 20:56:52 -0600 (CST) Christoph Lameter <cl@linux-foundation.org> wrote:
> >
> >> The second stage of the cpu_alloc patchset can be pulled from
> >>
> >> kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2
> >
> > Please send the patches for review.  Always.
> 
> Well okay can we define a process how to get patches merged with the -next 
> tree involved? It was nice when you handled all of this but the last 
> version of the cpu_alloc was thrown out of mm because of a -next conflict 
> and so it seemed better to go to the source than risk this again.
> 
> > I've forgotten how this whole cpu_alloc thing worked and now it's all
> > stuffed away in some git tree somewhere.  Oh well, whee...
> 
> Ok so post a patchset to lkml and at the same time offer a git tree?

Sure.

For important things I think it doesn't hurt to resend even if they've
been "reviewed" beforehand.  Particularly if you don't think enough
attention was paid to them.

These patches are a good example of that.  By the time 2.6.29 opens
everyone will have forgotten what all this stuff does and how it
works.

We need to get alpha sorted out too.  Frankly, if we can't get anyone to
review/test/ack the alpha genirq conversion then I'd say merge it
anyway.  I'll make sure that it at least compiles.
