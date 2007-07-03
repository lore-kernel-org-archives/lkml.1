Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXGCWPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXGCWPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXGCWPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:15:36 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50463 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbXGCWPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:15:35 -0400
Date: Tue, 3 Jul 2007 18:15:22 -0400
To: Mingming Cao <cmm@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-ID: <20070703221522.GE14074@fieldses.org>
References: <1183275424.4010.126.camel@localhost.localdomain> <1183388313.3864.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183388313.3864.35.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 10:58:33AM -0400, Mingming Cao wrote:
> Trond or Bruce, can you please review these patch series and ack if you
> agrees?

Thanks, looks like what we need!

How will nfsd tell whether it can really on a given filesystem's
i_version, or whether it should fall back on ctime?

> As to performance concerns that raise before the inode version counter
> (at least for ext4) is done inside ext4_mark_inode_dirty), so there is
> no extra IO work to store this counter to disk.

So what's the motivation for the "noversion" mount option?

--b.
