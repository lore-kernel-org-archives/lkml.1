Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbYBYW7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbYBYW7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbYBYW7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:59:14 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59875 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761307AbYBYW7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:59:13 -0500
Message-ID: <47C34838.3040502@garzik.org>
Date: Mon, 25 Feb 2008 17:59:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: David Miller <davem@davemloft.net>, krkumar2@in.ibm.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [git patches] net driver updates
References: <OF5F5F5698.07AB615F-ON652573F6.00142D8A-652573F6.00147DC9@in.ibm.com><20080220.214651.235108740.davem@davemloft.net><8A71B368A89016469F72CD08050AD334026D6511@maui.asicdesigners.com> <20080220.221554.128587906.davem@davemloft.net> <8A71B368A89016469F72CD08050AD334026D652F@maui.asicdesigners.com>
In-Reply-To: <8A71B368A89016469F72CD08050AD334026D652F@maui.asicdesigners.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
>> From: "Divy Le Ray" <divy@chelsio.com>
>> Date: Wed, 20 Feb 2008 21:57:08 -0800
>>
>>> The driver is cxgb3 here, it uses LLTX.
>> That's extremely unfortunate, hopefully you can update it to
>> use a model like tg3 and others use.  LLTX is a lost cause
>> for hardware device drivers, and in fact we'd like to remove
>> it tree wide eventually.
> 
> It sounds like I messed up.
> cxgb3 does not use LLTX - The Chelsio driver does, thus should be
> converted.

So, it sounds like Krishna's patch is ok, because the race does not 
exist anymore in this driver?

	Jeff



