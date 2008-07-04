Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYGDHjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYGDHjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 03:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYGDHj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 03:39:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYGDHj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 03:39:29 -0400
Date: Fri, 4 Jul 2008 03:39:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: steiner@sgi.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(),
	zap_page_range() & follow_page()
Message-ID: <20080704073926.GA1449@infradead.org>
References: <20080703213348.489120321@attica.americas.sgi.com> <20080703213633.890647632@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703213633.890647632@attica.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 04:34:00PM -0500, steiner@sgi.com wrote:
> +EXPORT_SYMBOL_GPL(zap_page_range);
>  
>  /*
>   * Do a quick page-table lookup for a single page.
> @@ -1089,6 +1090,7 @@ no_page_table:
>  	}
>  	return page;
>  }
> +EXPORT_SYMBOL_GPL(follow_page);

NACK.

These should never be called by a driver and suggest you need to rething
your VM integration in this driver.

