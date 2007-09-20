Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbXITR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbXITR0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXITR0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:26:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46459 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbXITR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:26:08 -0400
Subject: Re: [PATCH] docuement filesystem helpers for custom 'struct file's
From: Dave Hansen <haveblue@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070919150724.4e64829a.randy.dunlap@oracle.com>
References: <20070917182718.70494C9B@kernel>
	 <20070917182718.A6B9F7FD@kernel> <20070919172611.GA20917@infradead.org>
	 <1190224043.26982.112.camel@localhost>
	 <20070919150724.4e64829a.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 10:25:56 -0700
Message-Id: <1190309156.26982.144.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 15:07 -0700, Randy Dunlap wrote:
> 
> They aren't quite in kernel-doc format.  Holler if you need help
> with that, or see examples, or
> Documentation/kernel-doc-nano-HOWTO.txt.

Should we do comments for every single function argument, or is it OK to
leave them out for the obvious ones?

init_file() gets really boring:

> + * init_file - initialize a 'struct file'
> + * @file: the already allocated 'struct file' to initialized
> + * @mnt: the vfsmount on which the file resides
> + * @dentry: the dentry for the file
> + * @mode: the file's mode
> + * @fop: the file's operations

Seems like a waste of space to me, but I'd be happy to do them if that's
the convention.

-- Dave

