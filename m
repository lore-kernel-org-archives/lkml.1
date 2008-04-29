Return-Path: <linux-kernel-owner+w=401wt.eu-S1764621AbYD2Pgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764621AbYD2Pgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYD2Pg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:36:29 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:54144 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbYD2Pg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:36:29 -0400
X-Greylist: delayed 737 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 11:36:28 EDT
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc 
To: bsn.0007@gmail.com
Cc: libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Ulrich Drepper <drepper@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20080429133201.GA9938@localhost.localdomain>
References: <20080429133201.GA9938@localhost.localdomain>
Date: Wed, 30 Apr 2008 00:21:09 +0900
Message-ID: <9167.1209482469@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Nagabhushan,

bsn.0007@gmail.com:
> I went through Bharata's RFC post on glibc based Union Mount readdir solution
> (http://lkml.org/lkml/2008/3/11/34) and have come up with patches
> against glibc to implement the same.
	:::

While I don't have objection against the implementation in userspace,
what will UnionMount handle about rmdir or rename dir?
Those systemcalls need to test whether the dir is *logically* empty or
not in kernel space, don't they?
And I am afraid that UnionMount has to implement the similar thing, but
it never mean to modify glibc is a bad idea.


Junjiro Okajima
