Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbXA3Ch0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbXA3Ch0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 21:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXA3Ch0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 21:37:26 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49871 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXA3ChZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 21:37:25 -0500
Date: Tue, 30 Jan 2007 08:12:31 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>,
       =?iso-8859-1?Q?S=E9bastien_Dugu=E9_=3Csebastien=2Edugue=40bull=2Enet?=.=?iso-8859-1?Q?=3E?=@qubit.in.ibm.com
Subject: Re: 2.6.20-rc6-mm1
Message-ID: <20070130024231.GA9497@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070127234928.64d8e437.akpm@osdl.org> <45BCD5A8.4090400@mbligh.org> <20070128150133.b4c9b093.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128150133.b4c9b093.akpm@osdl.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 03:01:33PM -0800, Andrew Morton wrote:
> On Sun, 28 Jan 2007 08:56:08 -0800
> "Martin J. Bligh" <mbligh@mbligh.org> wrote:
> 
> > > - It seems that people have been busy creating the need for this.  I had to
> > >   apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
> > >   errors.  And a number of patches were dropped due to no-compile or to
> > >   runtime errors.  Heaven knows how many runtime bugs were added.
> > 
> > dbench seems to panic on xfs / cfq ?
> 
> OK, I'll dump git-block.patch.  That means that the fsaio patches get
> temporarily dropped as well as they depend on git-block changes somewhat.

Would you like me to rework these back again to not depend on git-block ?

> 
> btw, I didn't actually include the list-aio patches in rc6-mm1 due to
> various discouraging-looking review comments - I'll be awaiting version 2
> there.

Regards
Suparna

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

