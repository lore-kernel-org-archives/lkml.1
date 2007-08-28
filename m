Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbXH1UnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbXH1UnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXH1Umy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:42:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36871 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXH1Umy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:42:54 -0400
Date: Tue, 28 Aug 2007 21:42:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Immediate Values - Powerpc Optimization Fix
Message-ID: <20070828204250.GA10008@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070820202355.684760993@polymtl.ca> <20070820202538.765121428@polymtl.ca> <20070828204006.GD10071@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828204006.GD10071@Krystal>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 04:40:06PM -0400, Mathieu Desnoyers wrote:
> Immediate Values Powerpc Optimization Fix
> 
> Fix a bad call to flush_icache_range(). The second parameter is the end address
> of the range, not the length.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Christoph Hellwig <hch@infradead.org>

If've just verified that this works for me, thanks.

