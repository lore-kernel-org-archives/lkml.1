Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbXJRDo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbXJRDo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760101AbXJRDov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:44:51 -0400
Received: from rtr.ca ([76.10.145.34]:2992 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbXJRDou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:44:50 -0400
Message-ID: <4716D6B1.8010309@rtr.ca>
Date: Wed, 17 Oct 2007 23:44:49 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 17 Oct 2007, David Miller wrote:
>> I believe that we have enough of a limited set of accessors to
>> sg->page that we can more aggressively encode things in the lower
>> bits.
>>
>> I'm thinking of encoding the low two bits of sg->page as
>> follows:
...
> Yes, that sounds sane.


It would be good to have something soon-ish.
This "dead at boot time" issue is impacting the general ability to test
patches against latest -git in time for the current merge window.

:)
