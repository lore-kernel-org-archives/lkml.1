Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYG3JZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYG3JZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYG3JZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:25:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbYG3JZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:25:20 -0400
Date: Wed, 30 Jul 2008 02:23:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Michael Holzheu <holzheu@de.ibm.com>
Subject: Re: [patch 01/15] kmsg: Kernel message catalog macros.
Message-Id: <20080730022354.76034424.akpm@linux-foundation.org>
In-Reply-To: <1217409221.11260.3.camel@localhost>
References: <20080728175355.734299984@de.ibm.com>
	<20080728175511.023246676@de.ibm.com>
	<20080730013059.4d411750.akpm@linux-foundation.org>
	<1217409221.11260.3.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 11:13:41 +0200 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Wed, 2008-07-30 at 01:30 -0700, Andrew Morton wrote:
> > On Mon, 28 Jul 2008 19:53:56 +0200 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > Numerous people want a facility like this for other-than-s390 use. 
> > Progress has been intermittent and appears to have stopped.  The
> > apparently-dead mailing list is archived here:
> > https://lists.linux-foundation.org/pipermail/lf_kernel_messages/.
> > 
> > I don't know what the future holds for that development effort, but the
> > requirement won't go away.  So one day someone is going to go and yank
> > your implementation out of arch/s390 and into generic code.
> > 
> > So I'd suggest that you start out that way.
> 
> Somehow I have hoped for an answer like that :-) The only thing that
> we'd have to do is find a proper place for the kmsg header file,
> include/linux/kmsg.h comes to mind. The kmsg-doc script can easily be
> change to check for multiple documentation directories, I was thinking
> about Documentation/kmsg/$ARCH for the architecture specific things and
> Documentation/kmsg for the generic parts.
> 

No objections from me.

It would be wonderful if someone could troll those list archives and
see if they can wake up the people who were involved in that effort. 
They probably won't help much with development but it would be useful if
we could get their review/design input.

