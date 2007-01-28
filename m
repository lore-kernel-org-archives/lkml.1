Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXA1TtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXA1TtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932794AbXA1TtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:49:13 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:24267 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932787AbXA1TtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:49:11 -0500
Message-ID: <45BCFE33.3000600@tls.msk.ru>
Date: Sun, 28 Jan 2007 22:49:07 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
References: <478459.76045.qm@web52503.mail.yahoo.com> <45BCDFAE.5090602@tmr.com>
In-Reply-To: <45BCDFAE.5090602@tmr.com>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
[]
> RAID-10 is not the same as RAID 0+1.

It is.  Yes, there's separate module for raid10, but what it - basically -
does is the same as raid0 module over two raid1 modules will do.  It's
just a bit more efficient (less levels, more room for optimisations),
easy to use (you'll have single array instead of at least 3), and a bit
more flexible;  at the same way it's less widely tested...

But the end result is basically the same for both ways.

/mjt
