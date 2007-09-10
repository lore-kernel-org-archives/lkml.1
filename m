Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXIJCSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXIJCSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 22:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbXIJCRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 22:17:51 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:47508 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbXIJCRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 22:17:50 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union Mount: Readdir approaches 
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       Jan Blunck <jblunck@suse.de>
In-Reply-To: <20070907173941.GB20360@filer.fsl.cs.sunysb.edu>
References: <20070907054618.GD1692@in.ibm.com> <E1ITYJK-0000xP-8h@jroun> <20070907075855.GG1692@in.ibm.com> <20070907173941.GB20360@filer.fsl.cs.sunysb.edu>
Date: Mon, 10 Sep 2007 11:16:43 +0900
Message-Id: <E1IUYpP-0000z6-BS@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Jeff,

"Josef 'Jeff' Sipek":
> Unless I missunderstood something, Unionfs uses the same approach. Even
> Unionfs's ODF branch does the same thing. The major difference is that we
> keep the cache in a file on a disk.

The approach unionfs-2.1.2 took differs from mine.
Major difference is,
- in this approach, the cache in struct file is the completed virtual
  disk block for the dir.
- readdir doesn't have to call vfs_readdir when the cache exists and is
  valid. simply calls filldir.
- it supports SEEK_END.


Junjiro Okajima
