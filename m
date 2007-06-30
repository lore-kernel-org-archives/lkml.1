Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXF3Kkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXF3Kkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbXF3Kkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:40:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56954 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbXF3Kkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:40:41 -0400
Date: Sat, 30 Jun 2007 11:40:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Neil Brown <neilb@suse.de>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
Message-ID: <20070630104038.GB24123@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>, Neil Brown <neilb@suse.de>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org
References: <20070624014528.GA17609@wotan.suse.de> <20070624014613.GB17609@wotan.suse.de> <18046.63436.472085.535177@notabene.brown> <467F71C6.6040204@yahoo.com.au> <20070625122906.GB12446@think.oraclecorp.com> <46807B32.6050302@yahoo.com.au> <18048.32372.40011.10896@notabene.brown> <468082FF.6090704@yahoo.com.au> <20070626122650.GL14224@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626122650.GL14224@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 08:26:50AM -0400, Chris Mason wrote:
> Since we're testing new code, I would just leave the blkdev address
> space alone.  If a filesystem wants to use fsblocks, they allocate a new
> inode during mount, stuff it into their private super block (or in the
> generic super), and use that for everything.  Basically ignoring the
> block device address space completely.

Exactly, same thing XFS does.

