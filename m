Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYFMHYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYFMHYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYFMHYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:24:09 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:37596 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753708AbYFMHYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:24:08 -0400
Date: Fri, 13 Jun 2008 09:24:05 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080613072405.GA3474@anita>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613030841.GC3700@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-06-13 13:08 +1000 schrieb Dave Chinner:

> This commit in 2.6.26 will probably fix it.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3

Well, the description points out solving issues regarding dealing with
ENOSPC shutting the fs not down when it is not really necessary. Does
this count here, where my fs is 
/dev/sda7             120G   12G  108G  10% /home
with inode usage of
/dev/sda7            125001728 1310022 123691706    2% /home

? May be, I am not experienced in inspecting filesystems...

Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
