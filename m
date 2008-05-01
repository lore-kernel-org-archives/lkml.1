Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbYEAVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbYEAVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761249AbYEAVZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:25:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760856AbYEAVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:25:50 -0400
Date: Thu, 1 May 2008 17:25:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, lucho@ionkov.net, ericvh@gmail.com,
       mingo@goodmis.org
Subject: Re: [PATCH] fix flags length in net 9p
In-Reply-To: <20080501141919.78b7dc4f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0805011721150.12785@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
 <20080501141919.78b7dc4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I added Ingo since I think he created the check ]

On Thu, 1 May 2008, Andrew Morton wrote:

> On Thu, 1 May 2008 17:08:05 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > Some files in the net/9p directory uses "int" for flags. This can
> > cause hard to find bugs on some architectures. This patch converts the
> > flags to use "long" instead.
>
> gargh.
>
> > This bug was discovered by doing an allyesconfig make on the -rt kernel
> > where checks are done to ensure all flags are of size sizeof(long).
>
> I was about to suggest that we do something like that...
>
> I wonder how messy it is.  I long ago lost the ability to follow the
> convolutions in include/linux/spinlock*.h :(  gotta patch?

It's not messy at all, it's actually quite elegant. I can pull it out of
the -rt tree, or perhaps Ingo can quickly whip one up as well.

Ingo, you want me to pull it out?

-- Steve

