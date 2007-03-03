Return-Path: <linux-kernel-owner+w=401wt.eu-S2992853AbXCCBSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992853AbXCCBSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992862AbXCCBSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:18:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992869AbXCCBSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:18:33 -0500
Date: Fri, 2 Mar 2007 17:18:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] free swap space of (re)activated pages
Message-Id: <20070302171818.d271348e.akpm@linux-foundation.org>
In-Reply-To: <45E88997.4050308@redhat.com>
References: <45E88997.4050308@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 15:31:19 -0500
Rik van Riel <riel@redhat.com> wrote:

> the attached patch frees the swap space of already resident pages
> when swap space starts getting tight, instead of only freeing up
> the swap space taken up by newly swapped in pages.
> 
> This should result in the swap space of pages that remain resident
> in memory being freed, allowing kswapd more chances to actually swap
> a page out (instead of rotating it back onto the active list).

Fair enough.   How do we work out if this helps things?
