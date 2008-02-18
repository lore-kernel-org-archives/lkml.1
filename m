Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYBROcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYBROcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYBROcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:32:15 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58190 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751339AbYBROcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:32:14 -0500
Date: Mon, 18 Feb 2008 15:31:58 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: atmel_spi clock polarity
Message-ID: <20080218153158.2ff8842a@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080218.231243.41197917.anemo@mba.ocn.ne.jp>
References: <20080216.223252.25909396.anemo@mba.ocn.ne.jp>
	<20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com>
	<20080218.231243.41197917.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 23:12:43 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> T0-T1 was relatively longer then T1-T2.  I suppose T1 is not the
> point of updating MR register, but the point of starting DMA transfer.

Aw. I see.

> Anyway, I will try your patch in a few days.

Ok, thanks. If it works, that would be great, but given your
description above I'm not sure if I dare hope for it.

Hmm...I suppose we could just use CSR0 for all transfers and not
bother updating MR. That might actually be cheaper than doing it
"the right way"...and allow us to support an arbitrary number of
chipselects instead of just four.

But I guess the AT91RM9200 won't be too happy about that...

Haavard
