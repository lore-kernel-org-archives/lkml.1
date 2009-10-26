Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZJZQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZJZQb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZJZQb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZJZQb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:31:57 -0400
Date: Mon, 26 Oct 2009 12:30:04 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       esandeen@redhat.com
Subject: Re: Unnecessary overhead with stack protector.
Message-ID: <20091026123004.297a0a25@katamari.usersys.redhat.com>
In-Reply-To: <20091021182636.63edbf72.akpm@linux-foundation.org>
References: <20091015183540.GA8098@redhat.com>
	<20091021182636.63edbf72.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 18:26:36 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 15 Oct 2009 14:35:41 -0400 Dave Jones <davej@redhat.com> wrote:
> 
> > 113c5413cf9051cc50b88befdc42e3402bb92115 introduced a change that
> > made CC_STACKPROTECTOR_ALL not-selectable if someone enables CC_STACKPROTECTOR.
> > 
> > We've noticed in Fedora that this has introduced noticable overhead on
> > some functions, including those which don't even have any on-stack variables.
> > 
> > According to the gcc manpage, -fstack-protector will protect functions with
> > as little as 8 bytes of stack usage. So we're introducing a huge amount
> > of overhead, to close a small amount of vulnerability (the >0 && <8 case).
> > 
> > The overhead as it stands right now means this whole option is unusable for
> > a distro kernel without reverting the above commit.
> > 
> 
> This looks like a fairly serious problem to me, but I'm confused by the
> commit ID.  February 2008 - is this correct?
> 

That date is pure fiction AFAICT. And the Mercurial kernel repo says May 2008...
Is there some way to get the date a change was merged into the official tree as
opposed to the date it was created in some other tree?
