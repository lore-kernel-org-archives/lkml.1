Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYCVWf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYCVWf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYCVWfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:35:13 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38833 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYCVWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:35:12 -0400
Date: Sat, 22 Mar 2008 18:34:27 -0400
Message-Id: <200803222234.m2MMYRJo005108@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ext3 lockdep warning in 2.6.25-rc6 
In-reply-to: Your message of "Sat, 22 Mar 2008 18:38:47 BST."
             <1206207527.6437.83.camel@lappy> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1206207527.6437.83.camel@lappy>, Peter Zijlstra writes:
> On Sat, 2008-03-22 at 10:37 -0400, Erez Zadok wrote:
> > I was building a kernel using "make -j 4" inside a unionfs, mounted on top
> > of ext3.  The kernel is vanilla 2.6.25-rc6 plus unionfs patches.  At some
> > point I forced a cache flush using "echo 3 > /proc/sys/vm/drop_caches" and I
> > got the lockdep warning below.  Note that unionfs doesn't appear to be
> > involved in this lockdep warning at all, so I suspect this is probably an
> > issue between jbd and ext3 directly.
> 
> Known issue, drop_caches isn't production quality.

Is this a general problem with drop_caches, or its interaction with
ext3/jbd?  If I get a similar lockdep warning with other file systems,
should I bother to report this to the respective f/s maintainers?

Thanks,
Erez.
