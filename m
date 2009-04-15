Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZDOVzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZDOVzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZDOVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:55:12 -0400
Received: from rtr.ca ([76.10.145.34]:46971 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZDOVzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:55:10 -0400
Message-ID: <49E657BC.6000707@rtr.ca>
Date: Wed, 15 Apr 2009 17:55:08 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
References: <49E4FAC6.1030400@garzik.org>	<20090415014930.GA29413@kroah.com>	<49E5480F.10501@garzik.org>	<20090415050947.GB3462@kroah.com>	<49E5EE41.3090505@rtr.ca>	<20090415073001.503b0361@infradead.org>	<49E5FF48.3030809@rtr.ca> <20090415125813.34c9a151@infradead.org>
In-Reply-To: <20090415125813.34c9a151@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 15 Apr 2009 11:37:44 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Arjan van de Ven wrote:
>>> On Wed, 15 Apr 2009 10:25:05 -0400
>>> Mark Lord <lkml@rtr.ca> wrote:
..
>>>> Not forever, just a few seconds to compensate for the regression.
>>> seconds!!!!!
>>> The whole kernel boots in half a second!
>> ..
>>
>> Oh, absolutely I agree.
>>
>> That's why I'm not suggesting a DELAY
>> but rather a TIMEOUT (where it keeps trying up until the timeout).
> 
> This exists today. It's just not something Jeff chose to use ;)
> (because he didn't need to)
> 
>> For desktop, it should really just wait forever,
>> but I can understand situations (server room)
>> where that would be a Really Bad Idea.
> 
> it's called rootwait and such :)
..

No, that's not the same thing.
rootwait has no timeout -- it waits *forever*,
which will break auto-recovery on servers.

We just need it to wait/retry up to a timeout (parameter?).

Thanks
