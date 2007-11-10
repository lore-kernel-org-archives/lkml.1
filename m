Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbXKJP4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbXKJP4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXKJP4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:56:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60293 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbXKJP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:56:15 -0500
Date: Sat, 10 Nov 2007 15:56:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Koeller <thomas@koeller.dyndns.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Include header required for INT_MAX
Message-ID: <20071110155613.GB22418@infradead.org>
References: <20071110145627.C6FE347A7C@mail.koeller.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110145627.C6FE347A7C@mail.koeller.dyndns.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 03:55:15PM +0100, Thomas Koeller wrote:
> cdrom.h uses INT_MAX, so it must include kernel.h or
> limits.h (userspace) for a definition.

Nack, we shoiuld never include userspace headers in kernel headers,
an even more never add !__KERNEL__ ifdefs.  Just make sure your
programs include limit.h before including linux/cdrom.h.

