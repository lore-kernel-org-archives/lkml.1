Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbXFGKF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbXFGKF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbXFGKFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:05:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57129 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752617AbXFGKFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:05:49 -0400
Date: Thu, 7 Jun 2007 11:10:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miloslav Trmac <mitr@redhat.com>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Steve Grubb <sgrubb@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
Message-ID: <20070607111034.18bf68b6@the-village.bc.nu>
In-Reply-To: <20070606174113.b7fc31da.akpm@linux-foundation.org>
References: <4666832D.8080603@redhat.com>
	<46668814.7080404@redhat.com>
	<20070606174113.b7fc31da.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +			if (filp->f_op->read == tty_read) {
> > +				disable = 0;
> > +				break;

Why says a tty will always have f->op->read == tty_read ?

