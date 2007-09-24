Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbXIXHla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbXIXHla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXIXHlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:41:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55497 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbXIXHlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:41:15 -0400
Date: Mon, 24 Sep 2007 08:41:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Move kasprintf.o to obj-y
Message-ID: <20070924074110.GA7721@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, devel@openvz.org
References: <20070924071826.GA6757@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924071826.GA6757@localhost.sw.ru>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 11:18:26AM +0400, Alexey Dobriyan wrote:
> Modular puppyvisor started giving linking errors
> 
> 	  MODPOST 1 modules
> 	ERROR: "kasprintf" [drivers/lguest/lg.ko] undefined!

Please kill lib-y while you're at it.  It's useless and a constant
source of pain like this.

