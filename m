Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXA3Cmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXA3Cmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 21:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbXA3Cmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 21:42:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbXA3Cml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 21:42:41 -0500
Date: Mon, 29 Jan 2007 18:42:28 -0800
From: Andrew Morton <akpm@osdl.org>
To: suparna@in.ibm.com
Cc: "Martin J. Bligh" <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>,
       "=?ISO-8859-1?B?U+liYXN0aWVuIER1Z3Xp?= @qubit.in.ibm.com" 
	<sebastien.dugue@bull.net>
Subject: Re: 2.6.20-rc6-mm1
Message-Id: <20070129184228.49fd48e7.akpm@osdl.org>
In-Reply-To: <20070130024231.GA9497@in.ibm.com>
References: <20070127234928.64d8e437.akpm@osdl.org>
	<45BCD5A8.4090400@mbligh.org>
	<20070128150133.b4c9b093.akpm@osdl.org>
	<20070130024231.GA9497@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 08:12:31 +0530
Suparna Bhattacharya <suparna@in.ibm.com> wrote:

> On Sun, Jan 28, 2007 at 03:01:33PM -0800, Andrew Morton wrote:
> > On Sun, 28 Jan 2007 08:56:08 -0800
> > "Martin J. Bligh" <mbligh@mbligh.org> wrote:
> > 
> > > > - It seems that people have been busy creating the need for this.  I had to
> > > >   apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
> > > >   errors.  And a number of patches were dropped due to no-compile or to
> > > >   runtime errors.  Heaven knows how many runtime bugs were added.
> > > 
> > > dbench seems to panic on xfs / cfq ?
> > 
> > OK, I'll dump git-block.patch.  That means that the fsaio patches get
> > temporarily dropped as well as they depend on git-block changes somewhat.
> 
> Would you like me to rework these back again to not depend on git-block ?

Is OK thanks, I now have a git-block minus CFQ changes, so I have restored the fsaio
patches.

