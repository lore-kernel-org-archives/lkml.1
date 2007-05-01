Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbXEAIyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbXEAIyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXEAIyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:54:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55962 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbXEAIyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:54:32 -0400
Date: Tue, 1 May 2007 09:54:31 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kenchen@google.com
Subject: cache-pipe-buf-page-address-for-non-highmem-arch.patch
Message-ID: <20070501085431.GD14364@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kenchen@google.com
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  cache-pipe-buf-page-address-for-non-highmem-arch.patch

I still don't like this one at all.  If page_address on x86_64 is too
slow we should fix the root cause.

