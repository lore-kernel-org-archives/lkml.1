Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZKCKGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZKCKGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbZKCKGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:06:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbZKCKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:06:43 -0500
Date: Tue, 3 Nov 2009 05:06:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: device-mapper development <dm-devel@redhat.com>
Cc: Laurent CORBES <laurent.corbes@smartjog.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [dm-devel] Re: Ext3 sequential read performance drop 2.6.29 ->
	2.6.30,2.6.31,...
Message-ID: <20091103100645.GA13118@infradead.org>
References: <20091013120955.6bd5844b@smartjog.com> <20091102135554.b10ece3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102135554.b10ece3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 01:55:54PM -0800, Andrew Morton wrote:
> On Tue, 13 Oct 2009 12:09:55 +0200
> Laurent CORBES <laurent.corbes@smartjog.com> wrote:
> 
> > Hi all,
> > 
> > While benchmarking some systems I discover a big sequential read performance
> > drop using ext3 on ~ big files. The drop seems to be introduced in 2.6.30. I'm
> > testing with 2.6.28.6 -> 2.6.29.6 -> 2.6.30.4 -> 2.6.31.3.
> 
> Seems that large performance regressions aren't of interest to this
> list :(

No sure which list you mean, but dm-devel is for dm, not md.  We're also
seeing similarly massive performance drops with md and ext3/xfs as
already reported on the list.  Someone tracked it down to writeback
changes as usual, but there it got stuck.

