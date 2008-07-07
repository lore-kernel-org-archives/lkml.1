Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYGGWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYGGWJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYGGWJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:09:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43065 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbYGGWJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:09:09 -0400
Message-ID: <487293F8.30405@garzik.org>
Date: Mon, 07 Jul 2008 18:08:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Miller <davem@davemloft.net>, mchan@broadcom.com,
       dwmw2@infradead.org, bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>	<1215421413.3189.199.camel@shinybook.infradead.org>	<1215456981.5532.20.camel@dell>	<20080707.143803.99767036.davem@davemloft.net> <20080707221950.3dfba435@the-village.bc.nu>
In-Reply-To: <20080707221950.3dfba435@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Who in the world is going to actually want request_firmware() to find
>> a firmware image other than the one which has been properly tested
>> together with the driver by the driver maintainer?
> 
> That misses the point, intentionally I am sure. In the majority of cases
> the firmware doesn't change between releases so shipping a billion copies
> of is a pain in the butt.
> 
>> What "use case" is there other than the desire to seperate out the
>> firmware in order to skirt the legal issues?
> 
> Not shipping lots of copies
> Not leaving crap locked in kernel memory when it isn't needed
> Letting vendors issue firmware updates (which especially in enterprise
> space is a big issue and right now gets messy with compiled in firmware)

Do these benefits justify the removal of an actively used feature, one 
more reliable than its replacement?


>> I think it is, in fact, the driver maintainer's perogative of whether
>> they want request_firmware() to be supported by their driver or not.
>> It is they who have to deal with any possible fallout.
> 
> And their users and the distributors for whom it can cause enormous pain.

Where is this enormous pain associated with tg3's compiled-in firmware? 
  It's been quite convenient.

	Jeff



