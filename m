Return-Path: <linux-kernel-owner+w=401wt.eu-S1030816AbXCTCCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030816AbXCTCCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 22:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966071AbXCTCCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 22:02:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966074AbXCTCCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 22:02:37 -0400
Date: Mon, 19 Mar 2007 18:02:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew Morton <akpm@linux-found\"Michal Piotrowski\"" 
	<michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "\"Nick Piggin\" ation.org>" <nickpiggin@yahoo.com.au>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Message-Id: <20070319180234.6b7826b2.akpm@linux-foundation.org>
In-Reply-To: <20070319175852.c73406f1.akpm@linux-foundation.org>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	<45FEE33C.1020706@googlemail.com>
	<20070319140827.285dcc7f.akpm@linux-foundation.org>
	<6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>
	<20070319175852.c73406f1.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 17:58:52 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> The kernel without Nick's patchset but with the assert runs OK too.  Under
> the principle of mm-has-been-too-flakey-lately, I'll drop the patches:
> 
> mm-debug-check-for-the-fault-vs-invalidate-race.patch
> mm-simplify-filemap_nopage.patch
> mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
> mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
> mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
> mm-merge-nopfn-into-fault.patch
> mm-merge-nopfn-into-fault-fix.patch
> mm-remove-legacy-cruft.patch

ug, too many rejects.  I'll leave them in, minus
mm-debug-check-for-the-fault-vs-invalidate-race.patch
