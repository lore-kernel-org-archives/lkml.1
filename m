Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZARTnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZARTnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZARTnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:43:09 -0500
Received: from waste.org ([66.93.16.53]:50047 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZARTnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:43:08 -0500
Subject: Re: [Patch] slob: clean up the code
From: Matt Mackall <mpm@selenic.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cl@linux-foundation.org,
       penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20090118180038.GB3292@hack.private>
References: <20090118180038.GB3292@hack.private>
Content-Type: text/plain; charset=utf-8
Date: Sun, 18 Jan 2009 13:41:58 -0600
Message-Id: <1232307718.5202.14.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 02:00 +0800, Américo Wang wrote:
> - Use NULL instead of plain 0;

Good.

> - Rename slob_page() to is_slob_page();

Ok.

> - Define slob_page() to convert void* to struct slob_page*;

Ok. The general "struct page vs page" confusion isn't really improved by
this but at least this makes it a bit less ugly.

> - Rename slob_new_page() to slob_new_pages();

Don't care about this one. We've long had a notion of a "high order
page" (singular) of size 2^n pages.

> - Define slob_free_pages() accordingly.

This is a trivial wrapper function with one user.

But this patch is probably fine in it's current form, I don't care
enough about the above to respin it.

Signed-off-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


