Return-Path: <linux-kernel-owner+w=401wt.eu-S1765361AbZDCNun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765361AbZDCNun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764152AbZDCNuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:50:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764230AbZDCNuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:50:11 -0400
Date: Fri, 3 Apr 2009 09:50:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: nickpiggin@yahoo.com.au, hch@infradead.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] CacheFiles: Revert the addition of write_one_page()
Message-ID: <20090403135007.GB31907@infradead.org>
References: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk> <20090403094143.9510.80474.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403094143.9510.80474.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 10:41:43AM +0100, David Howells wrote:
> Revert the addition of the write_one_page() address space op as CacheFiles now
> uses the write() file op instead.

Note that in the patch series going into mainline eventually this should
not be a separate patch but the new ops should never be introduced.

