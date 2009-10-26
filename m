Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZJZQ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZJZQ6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZJZQ6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZJZQ6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:58:19 -0400
Date: Mon, 26 Oct 2009 12:56:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       esandeen@redhat.com
Subject: Re: Unnecessary overhead with stack protector.
Message-ID: <20091026125615.6dcc1e0e@katamari.usersys.redhat.com>
In-Reply-To: <20091026093706.c6416715.akpm@linux-foundation.org>
References: <20091015183540.GA8098@redhat.com>
	<20091021182636.63edbf72.akpm@linux-foundation.org>
	<20091026123004.297a0a25@katamari.usersys.redhat.com>
	<20091026093706.c6416715.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 09:37:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > > This looks like a fairly serious problem to me, but I'm confused by the
> > > commit ID.  February 2008 - is this correct?
> > > 
> > 
> > That date is pure fiction AFAICT. And the Mercurial kernel repo says May 2008...
> > Is there some way to get the date a change was merged into the official tree as
> > opposed to the date it was created in some other tree?
> 
> oh, so someone _did_ read my email!
> 
> 
> git show --pretty=fuller 113c5413cf9051cc50b88befdc42e3402bb92115
> 
> commit 113c5413cf9051cc50b88befdc42e3402bb92115
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Thu Feb 14 10:36:03 2008 +0100
> Commit:     Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon May 26 16:15:32 2008 +0200
> 
> I think the CommitDate is when it hit mainline.

The X-Git-Tag from the web page says it first appeared in mainline in
2.6.30-rc1:

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Feb 2008 09:36:03 +0000 (+0100)
Subject: x86: unify stackprotector features
X-Git-Tag: v2.6.30-rc1~2^2~50^2~67^2~11
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=113c5413c

Looks like it went through three merges on the way there?
