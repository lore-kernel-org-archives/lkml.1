Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbXEQRdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbXEQRdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbXEQRdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:33:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756915AbXEQRdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:33:14 -0400
Date: Thu, 17 May 2007 10:31:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALPHA: MARVEL - check for allocated memory
Message-Id: <20070517103113.107f4363.akpm@linux-foundation.org>
In-Reply-To: <20070517143712.GA8991@cvg>
References: <20070516181214.GA16348@cvg>
	<20070516114455.c0ee691e.akpm@linux-foundation.org>
	<20070517143712.GA8991@cvg>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 18:37:12 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Andrew Morton - Wed, May 16, 2007 at 11:44:55AM -0700]
> | On Wed, 16 May 2007 22:12:14 +0400
> | Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | 
> | > This patch adds checking for allocated memory
> | > which is used to hold AGP info. Also some whitespace
> | > cleanup.
> | 
> | The inclusion of all the whitespace fixies makes it rather hard to
> | see what the patch actually does.
> | 
> | I'm not sure that I can be bothered with this, really.  afaict the
> | checks you're adding are for boot-time allocations which we tend
> | to assume won't fail, and they're kmalloc(small-amount, GFP_KERNEL)
> | which is basically infallible, and it only affects, err, alpha.
> | 
> 
> So you think we could leave all as is? I mean sould I just drop the patch?

mutter.  I spose we should fix those sites which can be called at times other than
system boot.  Often one can use the lack of __init annotation to work out if a site
is being called after boot.
