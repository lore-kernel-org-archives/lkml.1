Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbXDMMN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbXDMMN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbXDMMN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:13:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbXDMMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:13:57 -0400
Date: Fri, 13 Apr 2007 13:13:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] generic rwsems
Message-ID: <20070413121348.GA28335@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, Nick Piggin <npiggin@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20070413102518.GD31487@wotan.suse.de> <20070413100416.GC31487@wotan.suse.de> <25428.1176464690@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25428.1176464690@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 12:44:50PM +0100, David Howells wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > I think I should put wait_lock after wait_list, so as to get a better
> > packing on most 64-bit architectures.
> 
> It makes no difference.  struct lockdep_map contains at least one pointer and
> so is going to be 8-byte aligned (assuming it's there at all).  struct
> rw_semaphore contains at least one pointer/long, so it will be padded out to
> 8-byte size.

I hope people are not going to enabled lockdep on their production systems :)

