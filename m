Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbYESP3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbYESP3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbYESP3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:29:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53019 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762544AbYESP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:29:39 -0400
Message-ID: <48319CC2.705@firstfloor.org>
Date: Mon, 19 May 2008 17:29:06 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Hellwig <hch@infradead.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
References: <20080519231.561421028@firstfloor.org>	<20080519123111.97C0C1B41FF@basil.firstfloor.org>	<20080519140339.GB24267@infradead.org>	<483191F9.3010706@firstfloor.org> <20080519161224.030b82c3@core>
In-Reply-To: <20080519161224.030b82c3@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 19 May 2008 16:43:05 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> I'd rather do a properly flag day and move lock_kernel into the
>>> instances instead of adding this _unlocked gunk.
>> I've considered that, but it's a bit too many fasync instances
>> all over the tree, so I chose this method.
> 
> If I can do all the watchdog drivers in one go then we can do all the
> fasync interfaces in one go. It isn't that hard other than making sure
> people didn't hide them in odd places on platforms not usually built.

If it's that easy for you please audit the ones then I didn't cover yet and send 
me a list.

The good news is that none of them I looked at actually needed BKL
(or perhaps I just missed it)

-Andi

