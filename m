Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbXKWRhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbXKWRhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 12:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXKWRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 12:37:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbXKWRh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 12:37:29 -0500
Date: Fri, 23 Nov 2007 17:37:23 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] Use _META bio I/O types for metadata I/O
Message-ID: <20071123173723.GA12227@infradead.org>
References: <20071122003512.GI114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122003512.GI114266761@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 11:35:12AM +1100, David Chinner wrote:
> Improve metadata I/O merging in the elevator
> 
> Change all async metadata buffers to use [READ|WRITE]_META I/O types
> so that the I/O doesn't get issued immediately. This allows merging
> of adjacent metadata requests but still prioritises them over bulk
> data. This shows a 10-15% improvement in sequential create speed of
> small files.
> 
> Don't include the log buffers in this classification - leave them
> as sync types so they are issued immediately.

Looks good, and just including the trivial fs.h addition here might be
okay aswell.

