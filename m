Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXIXSTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXIXSTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbXIXSTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:19:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54635 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbXIXSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:19:40 -0400
Date: Mon, 24 Sep 2007 19:19:31 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070924181931.GA3810@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca> <20070924175044.GD1608@infradead.org> <20070924105632.009aba7f.randy.dunlap@oracle.com> <20070924180041.GB2435@infradead.org> <20070924111318.f16cde07.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924111318.f16cde07.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 11:13:18AM -0700, Randy Dunlap wrote:
>  Documentation/trace/src/Makefile     |    7 +
>  Documentation/trace/src/README       |   18 +
>  Documentation/trace/src/fork_trace.c |  119 +++++++
>  Documentation/trace/trace.txt        |  164 ++++++++++
>  include/linux/trace.h                |   99 ++++++
>  lib/Kconfig                          |    9 +
>  lib/Makefile                         |    2 +
>  lib/trace.c                          |  563 +++++++++++++++++++++++++++
> +++++++
>  8 files changed, 981 insertions(+), 0 deletions(-)
> 
> 
> All of the trace/src/ subdirectory?

Yes, but only as a single file.  We don't really want READMES in source
directories.  Instead these 18 lines would do a perfect comment on the
top of the file.
