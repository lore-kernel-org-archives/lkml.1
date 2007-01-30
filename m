Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbXA3Tka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbXA3Tka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXA3Tka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:40:30 -0500
Received: from mail.enyo.de ([212.9.189.167]:4905 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbXA3Tka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:40:30 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com>
	<877iv4ljai.fsf@mid.deneb.enyo.de> <20070130191231.GH20642@kroah.com>
Date: Tue, 30 Jan 2007 20:40:10 +0100
In-Reply-To: <20070130191231.GH20642@kroah.com> (Greg KH's message of "Tue, 30
	Jan 2007 11:12:31 -0800")
Message-ID: <87ejpce21x.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH:

>> This reminds of the the utterly broken dl2k network driver (which has
>> got interrupt handling problems and doesn't properly synchronize with
>> DMA transfers, IIRC).  Hardware specs are available, and I guess I
>> could even provide a hardware sample, maybe even two.  (If the
>> community provides driver support, it shouldn't matter if the vendor
>> actually supports development.)
>
> Have you tried contacting the network driver developers to work these
> issues out?

Yes, sort of: <http://article.gmane.org/gmane.linux.kernel/448446>
There weren't any replies, unfortunately.  Do you think a repost would
make sense?

Our subsequent debugging revealed that either all the cards in our
sample were simply broken (but they seemed to work just fine with the
driver from FreeBSD-current), or something related to the DMA handling
in the driver was not quite right.  It looked as if the kernel and the
NIC couldn't agree on the contents of the ring buffer.
