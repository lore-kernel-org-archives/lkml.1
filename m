Return-Path: <linux-kernel-owner+w=401wt.eu-S1763579AbZFOTmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763579AbZFOTmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbZFOTmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:42:36 -0400
Received: from iph2.telenor.se ([195.54.127.133]:52998 "EHLO iph2.telenor.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396AbZFOTmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:42:35 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 15:42:34 EDT
X-SMTPAUTH: 
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUDAFI+NkrDNmV4mWdsb2JhbACBT5Z8AQEBAQEICwoHE71SgkuBQgU
X-IronPort-AV: E=Sophos;i="4.42,224,1243807200"; 
   d="scan'208";a="20278357"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjCrAMs+NkpV5HbzPGdsb2JhbACBT5ZyAQEBATe9V4JLgUIF
X-IronPort-AV: E=Sophos;i="4.42,224,1243807200"; 
   d="scan'208";a="537411540"
Message-ID: <4A36A1C2.2060805@mocean-labs.com>
Date: Mon, 15 Jun 2009 21:32:18 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Trilok Soni <soni.trilok@gmail.com>
CC: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
       Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [RESEND][PATCH] input: Added TSC2003
References: <4A366439.70005@mocean-labs.com> <5d5443650906151110u3f7d9d1cm1990e767d29a45b6@mail.gmail.com>
In-Reply-To: <5d5443650906151110u3f7d9d1cm1990e767d29a45b6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-06-15 20.10, Trilok Soni wrote:
> Hi,
> 
> On Mon, Jun 15, 2009 at 8:39 PM, Richard
> Röjfors<richard.rojfors.ext@mocean-labs.com> wrote:
>> Supplied is a driver for the TSC2003. There is actually a driver for TSC2007 which can be used in some cases.
>> The platform struct is reused from the TSC2007.
>> There is a big difference in the implementation between the drivers, this one does not use HR timers.
>> The TSC2007 driver performs synchronous I2C in the timer callback (SW IRQ context) which is bad when
>> the I2C driver is interrupt driven.
>>
> 
> Meaning? I think I2C transaction can sleep.

Yes that's what it means, and that's bad in a HR timer callback.

> I don't see (right now)
> need for two drivers. TSC2003 id was added to TSC2007. If you think
> TSC2007 doesn't provide enough support for it, then please add that in
> TSC2007 driver itself. We don't need create another driver it seems.

The chips are actually compatible (when it comes to the touchscreen functionality).

So you are true, the tsc2007 can be modified, I didn't added support for
the other pins anyway.

Actually I don't have access to any tsc2007, so I can't verify it on the newer chip.
I will go on and propose a patch.

--Richard
