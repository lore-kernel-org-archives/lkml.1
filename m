Return-Path: <linux-kernel-owner+w=401wt.eu-S934050AbZJIUYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbZJIUYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZJIUYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:24:39 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:43688 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZJIUYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IJw6/NyCq4ckFErwOS0XZFqF1hfQezi+08nr9KjXuoerUN3BqqaSR5+DsOFg/PNbBw
         3EMxs2aO5PeAv9ht83kr+hWwczx/GQ4yAueMaCfVKC0cEFeOgxXdT0t12JteIMZCrxsV
         NxoDciFCJy+eu5crBra5nbYhYZsi2thbqQYRA=
MIME-Version: 1.0
In-Reply-To: <20091009153219.GB7523@sortiz.org>
References: <1254988727-31726-1-git-send-email-vapier@gentoo.org> 
	<20091009153219.GB7523@sortiz.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 9 Oct 2009 16:23:42 -0400
Message-ID: <8bd0f97a0910091323x7392ccdcxf54f74d7f454110f@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v4] mfd: ADP5520 Multifunction LCD 
	Backlight and Keypad Input Device Driver
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 9, 2009 at 11:36, Samuel Ortiz wrote:
> On Thu, Oct 08, 2009 at 03:58:47AM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
>>
>> Subdevs:
>> LCD Backlight   : drivers/video/backlight/adp5520_bl
>> LEDs            : drivers/led/leds-adp5520
>> GPIO            : drivers/gpio/adp5520-gpio (ADP5520 only)
>> Keys            : drivers/input/keyboard/adp5520-keys (ADP5520 only)
>
> With your mfd core patch applied, adp5520-gpio.c and adp5520_bl.c are supposed
> to be buildable. Unfortunately, they both give build errors.
> So, you either provide me with a patch that fixes both of those, and I carry
> it with my mfd patchset, or you get your fixes applied upstream and I apply
> the mfd core patch after that.

yes, the typo fixes in this patch had pieces propagate to the other
drivers.  if you dont mind carrying the other patchsets, i can send
them all to you ;).  there should be like 3 or 4 of them.
-mike
