Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXLUOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXLUOnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbXLUOn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:43:28 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:60324 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756939AbXLUOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:43:25 -0500
X-Trace: 650827683/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.80
X-SBRS: None
X-RemoteIP: 81.1.89.80
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACNfa0dRAVlQ/2dsb2JhbACBV6do
Message-ID: <22602.85.118.17.158.1198248180.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20071221142222.GG11583@kernel.dk>
References: <8b67d60712201559h5dbb2a17q8f16223b26b88006@mail.gmail.com>
    <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com>
    <20071221121441.GB11583@kernel.dk>
    <8b67d60712210611j6169e262vd761b1d1aca75eb4@mail.gmail.com>
    <20071221142222.GG11583@kernel.dk>
Date: Fri, 21 Dec 2007 14:43:00 -0000 (UTC)
Subject: Re: [PATCH - SH/Dreamcast] Add support for GD-Rom device
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, "Paul Mundt" <lethal@linux-sh.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, December 21, 2007 2:22 pm, Jens Axboe wrote:
> On Fri, Dec 21 2007, Adrian McMenamin wrote:
>> On 21/12/2007, Jens Axboe <jens.axboe@oracle.com> wrote:
>> >
>> > Your design is also heavily geared towards there just being a single
>> > CDROM, I'm assuming this wont be a problem given your hw (it sets a
>> bad
>> > example for others to follow though, lots of violations against normal
>> > programming practice for multiple devices and smp).
>>
>>
>> Yes, because is there only one device and there will only ever be one
>> device (unless you know of somebody doing Dreamcast hardware
>> development).
>>
>> I understand the point you are making but adding in additional code
>> would only diminish resource availability or slow performance on a
>> small machine without actually delivering any better outcomes for
>> kernel users..
>>
>> Is it reaslly necessary?
>
> No it's not necessary, it was just a general reflection on how it could
> have been done more in style with "regular" drivers.
>


I have another look at the code, though i am anxious not to add to the
driver's footprint if it is not bring any real benefit. Let me see if
there is a way round that.

