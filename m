Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXA1XjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXA1XjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932995AbXA1XjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:39:01 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41903 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994AbXA1XjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:39:00 -0500
Date: Sun, 28 Jan 2007 15:38:49 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       =?ISO-8859-1?B?U+liYXN0aWVuIER1Z3Xp?= <sebastien.dugue@bull.net>
Subject: Re: 2.6.20-rc6-mm1
Message-Id: <20070128153849.8b6fbe26.akpm@osdl.org>
In-Reply-To: <45BD307F.6070705@mbligh.org>
References: <20070127234928.64d8e437.akpm@osdl.org>
	<45BCD5A8.4090400@mbligh.org>
	<20070128150133.b4c9b093.akpm@osdl.org>
	<45BD307F.6070705@mbligh.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 15:23:43 -0800
"Martin J. Bligh" <mbligh@mbligh.org> wrote:

> Andrew Morton wrote:
> > On Sun, 28 Jan 2007 08:56:08 -0800
> > "Martin J. Bligh" <mbligh@mbligh.org> wrote:
> > 
> >>> - It seems that people have been busy creating the need for this.  I had to
> >>>   apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
> >>>   errors.  And a number of patches were dropped due to no-compile or to
> >>>   runtime errors.  Heaven knows how many runtime bugs were added.
> >> dbench seems to panic on xfs / cfq ?
> > 
> > OK, I'll dump git-block.patch.  That means that the fsaio patches get
> > temporarily dropped as well as they depend on git-block changes somewhat.
> 
> 
> OK ... if you can dump something in hotfixes, it should hopefully
> auto-trigger another run. But OTOH, xfs on dbench seemed to do it
> reliably on a bunch of machines, so maybe it's easy to reproduce.
> 

I think I'll go for a quick rc6-mm2.
