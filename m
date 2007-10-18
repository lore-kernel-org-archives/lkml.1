Return-Path: <linux-kernel-owner+w=401wt.eu-S1762409AbXJRESW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762409AbXJRESW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXJRESN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:18:13 -0400
Received: from rtr.ca ([76.10.145.34]:1321 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbXJRESN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:18:13 -0400
Message-ID: <4716DE82.2050006@rtr.ca>
Date: Thu, 18 Oct 2007 00:18:10 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716DB9A.2060809@rtr.ca>
In-Reply-To: <4716DB9A.2060809@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> On Wed, 17 Oct 2007, Mark Lord wrote:
>>> It would be good to have something soon-ish.
>>> This "dead at boot time" issue is impacting the general ability to test
>>> patches against latest -git in time for the current merge window.
>>
>> In the meantime, does the patch I sent out help people? I'd like to 
>> get feedback, but I'm a lazy bum, and don't use DEBUG_PAGEALLOC 
>> myself, so I was hoping that people who actually see this could 
>> comment on my untested suggestion.
> 
> Oh.. so this bug is supposed to only bite with DEBUG_PAGEALLOC=y ??
> 
> Then something else is broken, perhaps.  I just saw a long traceback
> scroll off the top of the screen, with lots of bio_* functions in the list
> and assumed it was the same bug.
> 
> Mmm.. I'll get out the camera and try it again now..

Okay, mine is dying with EIP at blk_rq_map_sg+0xcb/0x160.

Screen photo is at http://rtr.ca/recent/2.6.23-git12-crash.jpg,
but the top was cut off (isn't there a new config option or patch
to do double-columns or scrollback or something ???.

Cheers
