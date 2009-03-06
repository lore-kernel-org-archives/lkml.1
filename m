Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZCFIjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZCFIjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZCFIjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:39:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbZCFIjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:39:39 -0500
Date: Fri, 6 Mar 2009 00:39:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
Message-Id: <20090306003900.a031a914.akpm@linux-foundation.org>
In-Reply-To: <49B0DE89.9000401@cn.fujitsu.com>
References: <49B0CAEC.80801@cn.fujitsu.com>
	<20090306082056.GB3450@x200.localdomain>
	<49B0DE89.9000401@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Mar 2009 16:27:53 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> > Let's not add wrapper for every two lines that happen to be used
> > together.
> > 
> 
> Why not if we have good reasons? And I don't think we can call this
> "happen to" if there are 250+ of them?

The change is a good one.  If a reviewer (me) sees it then you know the
code's all right and the review effort becomes less - all you need to check
is that the call site is using IS_ERR/PTR_ERR and isn't testing for
NULL.  Less code, less chance for bugs.

Plus it makes kernel text smaller.

Yes, the name is a bit cumbersome.
