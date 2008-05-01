Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYEABsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYEABsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYEABsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:48:21 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:56318 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYEABsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:48:20 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc 
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: "NAGABHUSHAN BS" <bsn.0007@gmail.com>, libc-alpha@sourceware.org,
       "Jan Blunck" <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       "Christoph Hellwig" <hch@lst.de>, "Ulrich Drepper" <drepper@redhat.com>,
       "Mingming Cao" <cmm@us.ibm.com>, "Dave Hansen" <haveblue@us.ibm.com>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <200804301635.m3UGZ7gn006259@agora.fsl.cs.sunysb.edu>
References: Your message of "Wed, 30 Apr 2008 11:37:10 +0530." <c810d5090804292307y2884b169t5c27b50fb7c94c30@mail.gmail.com> <200804301635.m3UGZ7gn006259@agora.fsl.cs.sunysb.edu>
Date: Thu, 01 May 2008 10:39:14 +0900
Message-ID: <7096.1209605954@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erez Zadok:
> Here's one idea:
> 
> 1. Your main data structure is a linear array of struct dirents.  You
	:::

All these points are very similar to the actual implementation in AUFS,
except 'Optimization 2: decide memory size by stat().'
- the size may not be enough for storing every dirent, it depends upon
  the filesystem's implementation.
- the size may be a block size which can be larger than page size even
  if it is a empty dir, also it depends upon the filesystem.


Junjiro Okajima
