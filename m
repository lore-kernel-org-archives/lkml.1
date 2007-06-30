Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbXF3KkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbXF3KkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXF3KkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:40:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56948 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbXF3KkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:40:06 -0400
Date: Sat, 30 Jun 2007 11:40:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Chris Mason <chris.mason@oracle.com>, Neil Brown <neilb@suse.de>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
Message-ID: <20070630104002.GA24123@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Chris Mason <chris.mason@oracle.com>, Neil Brown <neilb@suse.de>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org
References: <20070624014528.GA17609@wotan.suse.de> <20070624014613.GB17609@wotan.suse.de> <18046.63436.472085.535177@notabene.brown> <467F71C6.6040204@yahoo.com.au> <20070625122906.GB12446@think.oraclecorp.com> <46807B32.6050302@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46807B32.6050302@yahoo.com.au>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 12:34:26PM +1000, Nick Piggin wrote:
> That would require a new inode and address_space for the fsblock
> type blockdev pagecache, wouldn't it?

Yes.  That's easily possible, XFS already does it for it's own
buffer cache.

