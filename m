Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbXIAFRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbXIAFRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 01:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXIAFRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 01:17:39 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:49174 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbXIAFRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 01:17:38 -0400
X-Greylist: delayed 11530 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2007 01:17:38 EDT
Date: Sat, 1 Sep 2007 11:04:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: apw@shadowen.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hch@lst.de, mel@skynet.ie, dgc@sgi.com
Subject: Re: [RFC 14/26] SLUB: __GFP_MOVABLE and SLAB_TEMPORARY support
Message-Id: <20070901110410.acea7b2b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070901014222.536517408@sgi.com>
References: <20070901014107.719506437@sgi.com>
	<20070901014222.536517408@sgi.com>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 18:41:21 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> +#ifndef CONFIG_HIGHMEM
> +	if (s->kick || s->flags & SLAB_TEMPORARY)
> +		flags |= __GFP_MOVABLE;
> +#endif
> +

Should I do this as

#if !defined(CONFIG_HIGHMEM) && !defined(CONFIG_MEMORY_HOTREMOVE)

?

-Kame
