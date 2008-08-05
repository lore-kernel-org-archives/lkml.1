Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYHEA26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYHEA26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYHEA0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:26:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbYHEA0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:26:24 -0400
Date: Mon, 4 Aug 2008 20:26:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805002618.GA18215@infradead.org>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804223249.GA10517@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 03:32:49PM -0700, Greg KH wrote:
> >   1. Intercept file opens (exec also) for vetting (block until
> >   decision is made) and allow some userspace black magic to make
> >   decisions.

NACK, this kind of policy should be done in kernelspace.

> >   2. Intercept file closes for scanning post access

Not  even possible for mmap, and dumb otherwise, NACK.

> >   6. Scan files directly not relying on path.  Avoid races and problems with namespaces, chroot, containers, etc.

Explain? 

> >   9. Mark a processes as exempt from on access scanning

Nack, this completely defeats the purpose.

> >  11. Exclude sub-trees from scanning based on filesystem path
> >  12. Include only certain sub-trees from scanning based on filesystem path

Nack, please no pathname based idiocies.

