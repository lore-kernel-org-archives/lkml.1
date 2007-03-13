Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXCMM7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXCMM7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbXCMM7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:59:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45146 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313AbXCMM7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:59:54 -0400
Date: Tue, 13 Mar 2007 05:59:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: zach@vmware.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix vmi time header bug
Message-Id: <20070313055944.bf89eb9b.akpm@linux-foundation.org>
In-Reply-To: <200703131345.06514.ak@suse.de>
References: <45F5DB00.1070506@vmware.com>
	<20070312223136.dc6969f3.akpm@linux-foundation.org>
	<45F648B1.5000408@vmware.com>
	<200703131345.06514.ak@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 13:45:06 +0100 Andi Kleen <ak@suse.de> wrote:
> On Tuesday 13 March 2007 07:46, Zachary Amsden wrote:
> > Andrew Morton wrote:
> > > Really truly?   I think we have a _lot_ of declarations which omit the
> > > section qualifier altogether.  How come they don't all break too?
> >
> > User build was smoking this:
> >
> > make O=build -j16
> >
> > This and non-repeatable results make me suspect some kind of build
> > dependency problem, or perhaps a make bug.  Still, please apply, as it
> > doesn't hurt.
> 
> I don't think the patch should make any difference, so that's not needed.
> 

Correctly matching the section annotation on declarations and definitions
is needed by at least ARM.  We should ensure that we do this on all future
patches and we should also apply this patch if only for this reason.

(The ARM thing is a pain, because the compiler cannot check that the
definition and declaration match.  However something like sparse could do
so).

