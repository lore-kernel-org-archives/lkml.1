Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXFPTlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXFPTlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 15:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXFPTlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 15:41:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42687 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbXFPTlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 15:41:32 -0400
Date: Sat, 16 Jun 2007 20:41:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] madvise_need_mmap_write() usage
Message-ID: <20070616194130.GA6681@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nickpiggin@yahoo.com.au,
	Rik van Riel <riel@redhat.com>
References: <Pine.LNX.4.64.0706151118150.11498@dhcp83-20.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706151118150.11498@dhcp83-20.boston.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 11:20:31AM -0400, Jason Baron wrote:
> hi,
> 
> i was just looking at the new madvise_need_mmap_write() call...can we
> avoid an extra case statement and function call as follows?

Sounds like a good idea, but please move the assignment out of the
conditional.

