Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbXEFQV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbXEFQV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbXEFQV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:21:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53634 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbXEFQVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:21:25 -0400
Date: Sun, 6 May 2007 17:21:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Fix indentation in do_path_lookup
Message-ID: <20070506162123.GA5209@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
References: <20070506111124.GA1211@infradead.org> <11784654282342-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11784654282342-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 11:30:28AM -0400, Josef 'Jeff' Sipek wrote:
> +	if (unlikely(!retval && !audit_dummy_context() && nd &&
> +				nd->dentry && nd->dentry->d_inode))

the check for nd is not needed either as I hopefully mentioned in my
last mail. 

