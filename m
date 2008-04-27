Return-Path: <linux-kernel-owner+w=401wt.eu-S1762119AbYD0LvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762119AbYD0LvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 07:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYD0LvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 07:51:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55575 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755192AbYD0LvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 07:51:10 -0400
Date: Sun, 27 Apr 2008 06:51:06 -0500
From: Robin Holt <holt@sgi.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix file and descriptor handling in perfmon
Message-ID: <20080427115106.GC19717@sgi.com>
References: <E1JpvWk-0003lk-FT@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JpvWk-0003lk-FT@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not really an objection, just a simple comment.

On Sun, Apr 27, 2008 at 02:18:02AM +0100, Al Viro wrote:
...
> -static int
> -pfm_alloc_fd(struct file **cfile)
> +static struct file *pfm_alloc_file(pfm_context_t *ctx)

ZZZ
You mangle the style.  Not sure how important that is to Stephane, et
al.  They appear to use a two line function name which does make
searching with vi easier because /^pfm_alloc_file finds the function.

Thanks,
Robin Holt
