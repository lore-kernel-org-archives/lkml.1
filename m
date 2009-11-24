Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbZKXXIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbZKXXIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934308AbZKXXII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:08:08 -0500
Received: from fieldses.org ([174.143.236.118]:44236 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934173AbZKXXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:08:06 -0500
Date: Tue, 24 Nov 2009 18:08:52 -0500
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET 0-5] remove unneeded nfsd #includes
Message-ID: <20091124230852.GA468@fieldses.org>
References: <4B0C1EB7.50508@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0C1EB7.50508@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 07:58:15PM +0200, Boaz Harrosh wrote:
> Why is debug.h exported from Kernel? (include/linux/nfsd/Kbuild)

I suppose it's so rpcdebug can get the rpc debug flags; see e.g.
nfs-utils/tools/rpcdebug/rpcdebug.c.

--b.
