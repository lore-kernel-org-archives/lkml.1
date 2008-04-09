Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYDIN1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYDIN1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYDIN1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:27:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYDIN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:27:39 -0400
Date: Wed, 9 Apr 2008 09:27:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Please pull NFS client fixes against linux-2.6.25-rc8
Message-ID: <20080409132721.GA23852@infradead.org>
References: <1207703414.21370.1.camel@heimdal.trondhjem.org> <20080409082408.GA17458@infradead.org> <1207746758.8303.4.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207746758.8303.4.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 09:12:38AM -0400, Trond Myklebust wrote:
> That is what this does. For the case of no mmu, generic_file_mmap()
> compiles into a 'return -ENOSYS;'

doh, I was under the impression we had a real implementation now.
Of course then it makes much more sense to just not set .mmap at all,
which gives the same effect in a more obvious way and without any
confusion to the reader.  (actually that one gives -ENODEV which I
assume is for some reason more appropinquate)
