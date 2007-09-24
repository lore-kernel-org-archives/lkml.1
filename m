Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbXIXRiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbXIXRiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbXIXRiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:38:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40653 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXIXRiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:38:04 -0400
Date: Mon, 24 Sep 2007 18:37:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] Seq_file add support for sorted list
Message-ID: <20070924173759.GA1608@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070924164950.006047409@polymtl.ca> <20070924165426.841607414@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924165426.841607414@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 12:49:51PM -0400, Mathieu Desnoyers wrote:
> Add support for sorted list in seq_file. It aims at changing the way
> /proc/modules and kallsyms iterates on the module list to remove a race between
> module unload and module/symbol listing.
> 
> The list is sorted by ascending list_head pointer address.

While I think we really want this patch I don't quite see how it's
related to the markers.  I think patch 1 and 2 stand on their own.

