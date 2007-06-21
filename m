Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXFUQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXFUQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXFUQ3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:29:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38214 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXFUQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:29:16 -0400
Date: Thu, 21 Jun 2007 12:29:00 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Jan Blunck <jblunck@suse.de>,
       linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Message-ID: <20070621162900.GA9457@filer.fsl.cs.sunysb.edu>
References: <f5al1i$foi$1@sea.gmane.org> <200706201728.l5KHS9hj029372@agora.fsl.cs.sunysb.edu> <344eb09a0706202225i6743159x68e3a5416850eed3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <344eb09a0706202225i6743159x68e3a5416850eed3@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 10:55:45AM +0530, Bharata B Rao wrote:
... 
> Talking about copyup and whiteout at VFS layer, we have already
> demonstrated what complexity it takes to have these within VFS. Please
> take a look at the copyup and whiteout patches in our previous
> releases at:
> 
> http://lkml.org/lkml/2007/4/17/150
> http://lkml.org/lkml/2007/5/14/69
> 
> Or may be wait till I clean all those up to work with the new union
> new stack infrastructure which I have posted here.

Really, the problem for both, union mounts and unionfs, is that the concept
of unioning spans the two layers. You have the unification part - which is
very VFS-level concept, but at the same time, you got whiteouts, copyup,
(semi-?)persistent inode numbers, and a bunch of other details that just
don't belong in the VFS at all.

Josef "Jeff" Sipek.

-- 
Evolution, n.:
  A hypothetical process whereby infinitely improbable events occur with
  alarming frequency, order arises from chaos, and no one is given credit.
