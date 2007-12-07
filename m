Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbXLGCzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbXLGCzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 21:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXLGCzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 21:55:09 -0500
Received: from mail.fieldses.org ([66.93.2.214]:55768 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXLGCzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:55:08 -0500
Date: Thu, 6 Dec 2007 21:55:04 -0500
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: Re: [NFS] NFSv2/3 broken exporting/mounting (permission denied) in
	2.6.24-rc4
Message-ID: <20071207025504.GA3070@fieldses.org>
References: <200712070220.lB72Kfqw004530@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712070220.lB72Kfqw004530@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 09:20:41PM -0500, Erez Zadok wrote:
> I get a "permission denied" when trying to mount a localhost nfsv2/3
> exported volume, on v2.6.24-rc4-124-gf194d13.  It works w/ nfsv4 mounting.
> It worked fine in 2.6.24-rc3.  Here's a sequence of ops I tried:
> 
> # mount -t ext2 /dev/hdb1 /n/lower/b0
> # exportfs -o no_root_squash,rw localhost:/n/lower/b0
> # mount -t nfs -o nfsvers=3 localhost:/n/lower/b0 /mnt

What do you see if you watch the network traffic in ethereal?

--b.
