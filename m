Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZH2XQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZH2XQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZH2XQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:16:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZH2XQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:16:49 -0400
Date: Sat, 29 Aug 2009 19:16:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-ID: <20090829231650.GA29419@infradead.org>
References: <1251563892.13287.11.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251563892.13287.11.camel@wall-e>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 06:38:12PM +0200, Stefani Seibold wrote:
> The following fix a long standing issue in the proc_file_write function,
> which doesn't update the ppos file position pointer.

The right fix is to get rid of the last remaining
read_proc_t/write_proc_t instances and switch everyone to implement file
operations.  Alexey has been working on this on and off for a while.

