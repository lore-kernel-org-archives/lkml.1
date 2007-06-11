Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbXFKUfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbXFKUfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXFKUfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:35:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43435 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXFKUfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:35:21 -0400
Date: Mon, 11 Jun 2007 21:35:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       hch@lst.de
Subject: Re: [PATCH 1/2] PTRACE_PEEKDATA consolidation
Message-ID: <20070611203517.GA22252@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	hch@lst.de
References: <20070611204006.GC5715@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611204006.GC5715@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 12:40:06AM +0400, Alexey Dobriyan wrote:
> Identical implementations of PTRACE_PEEKDATA go into
> simple_ptrace_peekdata() function.
> 
> compile-tested on ~half of archs, playing with gdb on x86_64.

Looks good.  Why don't you call it generic_ptrace_peekdata instead of
simple_ptrace_peekdata, though?

