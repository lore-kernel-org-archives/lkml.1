Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbYKLQ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbYKLQ7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYKLQ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:58:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYKLQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:58:50 -0500
Date: Wed, 12 Nov 2008 11:58:21 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, arjan@infradead.org, greg@kroah.com,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH =-v3 07/21] fanotify: fastpath to ignore certain in
	core inodes
Message-ID: <20081112165820.GA26217@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com> <20081112161103.25434.30104.stgit@paris.rdu.redhat.com> <20081112165055.GB19669@infradead.org> <20081112165638.54c38c5c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112165638.54c38c5c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 04:56:38PM +0000, Alan Cox wrote:
> Sounds a good way of ruining the performance.

I don't think you can ruine performance of a system with AV systems
running even more.  While bloating the inode does cause enormous
problems in file serving or other extremly metadata intensive workloads.
