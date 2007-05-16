Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbXEPSra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbXEPSra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbXEPSrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:47:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415AbXEPSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:47:23 -0400
Date: Wed, 16 May 2007 11:44:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALPHA: MARVEL - check for allocated memory
Message-Id: <20070516114455.c0ee691e.akpm@linux-foundation.org>
In-Reply-To: <20070516181214.GA16348@cvg>
References: <20070516181214.GA16348@cvg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 22:12:14 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch adds checking for allocated memory
> which is used to hold AGP info. Also some whitespace
> cleanup.

The inclusion of all the whitespace fixies makes it rather hard to
see what the patch actually does.

I'm not sure that I can be bothered with this, really.  afaict the
checks you're adding are for boot-time allocations which we tend
to assume won't fail, and they're kmalloc(small-amount, GFP_KERNEL)
which is basically infallible, and it only affects, err, alpha.
