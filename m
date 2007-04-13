Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXDMKTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXDMKTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 06:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXDMKTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 06:19:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46945 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXDMKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 06:19:34 -0400
Date: Fri, 13 Apr 2007 11:19:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: fastcalls, was Re: [patch] generic rwsems
Message-ID: <20070413101930.GA13169@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <npiggin@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20070413100416.GC31487@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413100416.GC31487@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:04:16PM +0200, Nick Piggin wrote:
> Remove one level of indirection (kernel/rwsem.c -> lib/rwsem.c), and
> give a bit of a cleanup (eg remove the fastcall junk) to make the
> code a bit easier to read.

Arpopos fastcalls, now that -mregparam=3 is the defaul on i386 and
FASTCALL/fastcall is a noop everywhere else can we please get rid
of this attribute entirely?  If any other architecture provides
a more optimal non-standard calling convention we can just use
it by default in kernelspace as a few architectures already do.
