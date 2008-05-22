Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYEVGQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYEVGQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 02:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYEVGQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 02:16:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbYEVGQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 02:16:08 -0400
Date: Wed, 21 May 2008 23:15:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       wim@iguana.be, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 18/57] iTCO: unlocked_ioctl, coding style and cleanup
Message-Id: <20080521231545.acebac0f.akpm@linux-foundation.org>
In-Reply-To: <200805221556.27390.rusty@rustcorp.com.au>
References: <20080519124659.31722.51847.stgit@core>
	<200805211426.16234.rusty@rustcorp.com.au>
	<20080521102922.4f0c405d@core>
	<200805221556.27390.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 15:56:26 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 21 May 2008 19:29:22 Alan Cox wrote:
> > > I've been pulling out s/down_trylock/down_nowait/ patches which effect
> > > others' changes.  Those patches get moved to the end of my queue, and
> > > I'll revisit them before an actual merge with Linus.
> >
> > The watchdog drivers all got the semaphores removed in the patch set I
> > did so you can dump that bit.
> 
> Done, thanks.  Are you in linux-next yet?  Stephen is pretty good at telling 
> me about this kind of stuff...

Nope.  I haven't worked out how to get -mm into linux-next yet.  (Well,
I have, but I haven't worked out how to do it while getting Stephen to
do all the work ;))  Soon....

The route for these patches is via Wim - merge these into git-watchdog,
feed git-watchdog fed into linux-next.  Please.

