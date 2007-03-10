Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbXCJJzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbXCJJzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933449AbXCJJzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:55:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51184 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429AbXCJJzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:55:09 -0500
Date: Sat, 10 Mar 2007 09:55:08 +0000
From: Christoph Hellwig <hch@infradead.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, bjoern@j3e.de,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4]: ufs2 more correct work with time
Message-ID: <20070310095508.GA24090@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	bjoern@j3e.de, linux-fsdevel@vger.kernel.org
References: <20070310093002.GA757@rain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310093002.GA757@rain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 12:30:02PM +0300, Evgeniy Dushistov wrote:
> This patch corrects work with time in UFS2 case.
> 
> 1)According to UFS2 disk layout modification/access and so on "time"
> should be hold in two variables one 64bit for seconds and another
> 32bit for nanoseconds,
> 
> at now for some unknown reason we suppose
> that "inode time" holds in three variables 32bit for seconds, 32bit for
> milliseconds and 32bit for nanoseconds.
> 
> 2)We set amount of nanoseconds in "VFS inode" to 0 during read, instead
> of getting values from "on disk inode"(this should close
> http://bugzilla.kernel.org/show_bug.cgi?id=7991).


Looks good to me.

