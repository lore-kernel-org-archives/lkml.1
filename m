Return-Path: <linux-kernel-owner+w=401wt.eu-S1759770AbZFWPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbZFWPBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbZFWPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:01:46 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:34923 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643AbZFWPBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:01:45 -0400
Date: Tue, 23 Jun 2009 17:00:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-reply-to: <20090623105445.6bec978c@lxorguk.ukuu.org.uk>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: "'David Brownell'" <david-b@pacbell.net>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000901c9f413$70b2ece0$5218c6a0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acnz6IGntPzegSXITHq6U/PUNxN4WgAKnmsQ
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
 <200906222026.51511.david-b@pacbell.net>
 <001c01c9f3cd$ad02b1d0$07081570$%szyprowski@samsung.com>
 <200906230022.39040.david-b@pacbell.net>
 <002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
 <20090623102129.3b58adbf@lxorguk.ukuu.org.uk>
 <002101c9f3e5$b4dc5a10$1e950e30$%szyprowski@samsung.com>
 <20090623105445.6bec978c@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 23, 2009 11:55 AM, Alan Cox wrote:

> > Are there any drawbacks of disabling low_latency mode if callbacks
> are
> > done from tasklet not from interrupt?
> 
> Not really no

David: do you want to update a g_serial driver and disable the low latency
mode, or should I post a patch that does it? Or do you have other plan to
solve this issue? I tested the g_serial driver with low latency mode
disabled and it works quite fine here on ARM S3C6410.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


