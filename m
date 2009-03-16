Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZCPRZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZCPRZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZCPRZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:25:23 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58860 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbZCPRZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:25:22 -0400
Date: Mon, 16 Mar 2009 17:25:17 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com
Subject: Re: [patch] eventfd - remove fput() call from possible IRQ context (2nd rev)
Message-ID: <20090316172517.GC2453@shareable.org>
References: <49B8A75E.6040409@cosmosbay.com> <20090311233903.f036027a.akpm@linux-foundation.org> <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com> <1236986902.7265.73.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com> <1237003328.7265.98.camel@heimdal.trondhjem.org> <alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com> <20090315174445.GD18305@kvack.org> <alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> +	if (unlikely(req->ki_eventfd != NULL)) {

Is this really unlikely?  Having an eventfd seems to be the modern,
cool, recommended way to do AIO.

The other unlikelies look ok.

-- Jamie
