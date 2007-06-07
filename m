Return-Path: <linux-kernel-owner+w=401wt.eu-S1762668AbXFGOaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668AbXFGOaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbXFGOac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:30:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbXFGOab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:30:31 -0400
Message-ID: <46681417.5050200@redhat.com>
Date: Thu, 07 Jun 2007 16:20:07 +0200
From: Miloslav Trmac <mitr@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Steve Grubb <sgrubb@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
References: <4666832D.8080603@redhat.com>	<46668814.7080404@redhat.com>	<20070606174113.b7fc31da.akpm@linux-foundation.org> <20070607111034.18bf68b6@the-village.bc.nu>
In-Reply-To: <20070607111034.18bf68b6@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
>>> +			if (filp->f_op->read == tty_read) {
>>> +				disable = 0;
>>> +				break;
> Why says a tty will always have f->op->read == tty_read ?
AFAICS from tty_io.c, it will always be tty_read or hung_up_tty_read.
Normal user processes would exit after SIGHUP and not reopen a TTY.

(I have copied the condition from __do_SAK().  That of course doesn't
mean it's correct.)
	Mirek
