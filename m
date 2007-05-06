Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXEFNUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXEFNUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 09:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXEFNUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 09:20:36 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:3205 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXEFNUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 09:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=cy1VowrPWmJLYHb1WZbZT+1OzDkj8fGCpRXYiCFqqgq/o0DHZZCBzNZAw6P+LurzRzzdacza8g0QB3NWAWvx2MvMUGz3gijEgiNXE2GEbGuQiL86c41Zhovy64wDi1HwDEbthvygje4U7Ap+s/X92Hde7YE7JuVbUPauB6V2W4Q=
Date: Sun, 6 May 2007 16:20:35 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1258712175.20070506162035@gmail.com>
To: Bodo Eggert <7eggert@gmx.de>, Anton Vorontsov <cbou@mail.ru>
CC: Robin Getz <rgetz@blackfin.uclinux.org>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Stefan Roese <ml@stefan-roese.de>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Correct location for ADC/DAC drivers
In-Reply-To: <E1Hkfia-0000cJ-18@be1.lrz>
References: <8fZXU-3EI-11@gated-at.bofh.it> <8haHG-6zd-19@gated-at.bofh.it> <8hd2U-1Ca-39@gated-at.bofh.it> <8heii-3GM-37@gated-at.bofh.it> <E1Hkfia-0000cJ-18@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bodo,

Sunday, May 6, 2007, 3:19:59 PM, you wrote:

> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>> On Fri 4 May 2007 16:52, Robert Schwebel pondered:
>>> On Fri, May 04, 2007 at 02:21:50PM -0400, Robin Getz wrote:

>>> > We also have DAC and ADC drivers (up to 16 bits @ 64MS/s, via DMA),
>>> > that would be nice to put in the "right" place  - I don't think that
>>> > drivers/char is the right place, nor drivers/misc - I also don't think
>>> > that /adc is a descriptive place for DAC or mixed signal front ends
>>> > (MxFE).
>>>
>>> What userspace interface do your drivers have?
>> 
>> Right now, it is a little rudimentary char interface, it needs a little care
>> to be a bit more general purpose, but it suited needs of what the people who
>> were using it.

> [...]

>> I would be interested in having a detailed discussion/random thoughts on
>> this - what is the best way to expose these types of devices?

> Since you ask for random thoughts:

> IO of data streams from or to a DAC/ADC is essentially what soundcards do.
> I'm wondering if these cards are similar enough to use alsa, and if using
> that interface would ease or hinder programming the driver.


        FYI, within handhelds.org kernel project, we also saw the need
for consistent ADC infrastructure, and developed such, based on
classdev concept, on todo to be submitted for review. Our
API/userspace interface however optimized for individual (or
fixed-batch) readings over stream operations, our target usage
are touchscreen, battery, hwmon drivers.




-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

