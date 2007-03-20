Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbXCTE4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbXCTE4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbXCTE4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:56:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46339 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933997AbXCTE4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:56:48 -0400
Date: Mon, 19 Mar 2007 20:56:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Message-Id: <20070319205645.4918d978.akpm@linux-foundation.org>
In-Reply-To: <45FF4B59.3060107@yahoo.com.au>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	<45FEE33C.1020706@googlemail.com>
	<20070319140827.285dcc7f.akpm@linux-foundation.org>
	<6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>
	<20070319175852.c73406f1.akpm@linux-foundation.org>
	<20070319180234.6b7826b2.akpm@linux-foundation.org>
	<45FF4B59.3060107@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 13:47:53 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Andrew Morton wrote:
> > On Mon, 19 Mar 2007 17:58:52 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > 
> >>The kernel without Nick's patchset but with the assert runs OK too.  Under
> >>the principle of mm-has-been-too-flakey-lately, I'll drop the patches:
> >>
> >>mm-debug-check-for-the-fault-vs-invalidate-race.patch
> >>mm-simplify-filemap_nopage.patch
> >>mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
> >>mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
> >>mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
> >>mm-merge-nopfn-into-fault.patch
> >>mm-merge-nopfn-into-fault-fix.patch
> >>mm-remove-legacy-cruft.patch
> > 
> > 
> > ug, too many rejects.  I'll leave them in, minus
> > mm-debug-check-for-the-fault-vs-invalidate-race.patch
> > 
> 
> Hang on a sec... I'll try fixing the thing before you next make a
> release.
> 

Too late.  hot-fixes/ awaits thee.
