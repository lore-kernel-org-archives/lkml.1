Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXI3BgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXI3BgC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 21:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXI3Bfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 21:35:54 -0400
Received: from ozlabs.org ([203.10.76.45]:59768 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbXI3Bfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 21:35:53 -0400
Subject: Re: [patch 2/5] Linux Kernel Markers
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070928143159.299956378@polymtl.ca>
References: <20070928142845.795281397@polymtl.ca>
	 <20070928143159.299956378@polymtl.ca>
Content-Type: text/plain
Date: Sun, 30 Sep 2007 11:35:35 +1000
Message-Id: <1191116135.26950.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 10:28 -0400, Mathieu Desnoyers wrote:
> +struct __mark_marker;

Hi Mathieu,

	How about, "struct marker".  You've taken the "marker*" namespace, so
all these underscores are __gratuitious__ :)

> +/*
> + * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
> + * and module markers, the hash table and deferred_sync.
> + */
> +DEFINE_MUTEX(markers_mutex);

This can be static AFAICT.

The rest looks fine.

Cheers,
Rusty.

