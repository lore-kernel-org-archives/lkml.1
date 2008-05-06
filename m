Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbYEFFsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbYEFFsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYEFFru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:47:50 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:51806 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYEFFrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:47:49 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC PATCH 1/2] Union Mount: glibc readdir support 
To: bharata@linux.vnet.ibm.com
Cc: Ulrich Drepper <drepper@redhat.com>, bsn.0007@gmail.com,
       libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20080506042117.GA29298@in.ibm.com>
References: <20080429133201.GA9938@localhost.localdomain> <20080429133346.GB9938@localhost.localdomain> <48195E69.3030701@redhat.com> <20080506042117.GA29298@in.ibm.com>
Date: Tue, 06 May 2008 14:46:14 +0900
Message-ID: <6773.1210052774@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bharata B Rao:
> At the server side, I can't see how NFS server could export a union.
> I don't see how this could be sanely done with Union Mount. Erez, how
> does Unionfs handle this ?
> 
> Is dis-allowing NFS-exporting of unions an option ?

As a note, there were many requests for aufs to support NFS-exporting.
And it was already implemented. The encode/decode_fh functions in aufs
behave like sub-nfsd.


Junjiro Okajima
