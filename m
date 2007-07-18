Return-Path: <linux-kernel-owner+w=401wt.eu-S934999AbXGRQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934999AbXGRQmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbXGRQmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:42:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36902 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbXGRQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:42:06 -0400
Date: Wed, 18 Jul 2007 12:42:01 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Radoslaw Szkodzinski <astralstorm@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS -git changes and Linux-VServer patch porting
Message-ID: <20070718164201.GA2668@filer.fsl.cs.sunysb.edu>
References: <f44c5fdf0707180649h778f017dlb532c3ba224944b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44c5fdf0707180649h778f017dlb532c3ba224944b2@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 03:49:07PM +0200, Radoslaw Szkodzinski wrote:
> Linux-VServer patch adds 2 new flags: barrier and iunlink.
> With recent changes in -git (filestreams), XFS now lacks di_flags bits
> to add these.
> iunlink flag adds Copy-on-Write semantics to hard links, while barrier
> flag signifies a filesystem barrier no virtual context can pass.
> 
> I'd like to know how to possibly resolve this problem w/o negatively
> impacting performance (especially of iunlink) or changing on-disc
> format in an incompatible way, as well as being more future-proof.

A while back, I mentioned that it would be nice to have a whiteout inode
flag (I've since changed my mind) but the answer I got from Dave Chinner,
et. al., was to use xattrs.

Josef 'Jeff' Sipek.

-- 
If I have trouble installing Linux, something is wrong. Very wrong.
		- Linus Torvalds
