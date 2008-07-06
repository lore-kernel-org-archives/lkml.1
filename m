Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbYGFVje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbYGFVje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbYGFVjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:39:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37073 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225AbYGFVjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:39:22 -0400
Message-ID: <48713B73.6030708@garzik.org>
Date: Sun, 06 Jul 2008 17:38:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, andi@firstfloor.org, tytso@mit.edu,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <1215178035.10393.763.camel@pmac.infradead.org>	 <486E2818.1060003@garzik.org> <20080704142753.27848ff8@lxorguk.ukuu.org.uk>	 <20080704.134329.209642254.davem@davemloft.net>	 <20080704220444.011e7e61@lxorguk.ukuu.org.uk>	 <alpine.DEB.1.10.0807061311030.11010@asgard.lang.hm>	 <1215376034.3189.127.camel@shinybook.infradead.org>	 <alpine.DEB.1.10.0807061351040.11010@asgard.lang.hm> <1215377814.3189.137.camel@shinybook.infradead.org>
In-Reply-To: <1215377814.3189.137.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sun, 2008-07-06 at 13:52 -0700, david@lang.hm wrote:
>> On Sun, 6 Jul 2008, David Woodhouse wrote:
>>
>>> On Sun, 2008-07-06 at 13:17 -0700, david@lang.hm wrote:
>>>> if David W were to make it possible to not use the load_firmware() call to
>>>> userspace and build the firmware into the driver (be it in a monolithic
>>>> kernel or the module that contains the driver)
>>> You _can_ build the firmware into the kernel.
>> right, but not into a module. you have half of the answer in place, but 
>> not all of it.
> 
> The useful half. If you have userspace to load modules, you have
> userspace to load firmware too.

Existing examples have already been provided where this logic fails.

	Jeff



