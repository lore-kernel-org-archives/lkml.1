Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZFEEul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZFEEul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZFEEt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:49:59 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63861 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZFEEt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=up1gjkbLSHf3X9s1SIVw3ly5VA70OacFksoRC5CtQWV71BD/oqpPbn58RFKbcQet7e
         iJeC61crpYQMdj51TG4S7I4lfVdiTzGL16C5ZFj3KWEnSSUBmF+LDVzQV2IjDhJLkBYS
         M/efAsdLPWRojepHwf90eE6xNWKev6ywHkJxY=
MIME-Version: 1.0
In-Reply-To: <9e4733910906042103q6c21886cia02d33cb278cef1e@mail.gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	 <9e4733910906042103q6c21886cia02d33cb278cef1e@mail.gmail.com>
Date: Fri, 5 Jun 2009 08:49:57 +0400
Message-ID: <bc64b4640906042149pb83911bk4e0397da11f9fde6@mail.gmail.com>
Subject: Re: [RFC][WIP] IEEE 802.15.4 implementation for Linux v1
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/5 Jon Smirl <jonsmirl@gmail.com>:
> On Mon, Jun 1, 2009 at 10:54 AM, Dmitry
> Eremin-Solenikov<dbaryshkov@gmail.com> wrote:
>> Hi,
>>
>> As a part of research activities the Embedded Systems - Open Platform Group
>> from Siemens Corporate Technology we are working on adding support for
>> the IEEE 802.15.4 Wireless Personal Area Networks to the Linux. Our current
>> implementation is neither certified nor even feature complete. However
>> we'd like to present current state of our patchset to the Linux developers
>> community to gain comments, fixes, ideas, etc. This is not yet a pull request,
>> but more like an RFC.
>
> Does this stack work with the Atmel USB version of at86rf230?
> ATAVRRZUSBSTICK, http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4396

No, we do not support Atmel USB sticks, nor we do not have plans for
adding support
for it in the foreseable feature. However if the onboard ATmega can be
programmed to
provide usb-serial interface, one can use/adapt our serial discipline
driver to control it.
One will still have to write firmware for the on-stick ATmega chip.

Or you can add support for any existing interface that is provided by
RazorUSB card by yourself.
We tried to make mac802154 drivers easy to implement.

> It's not so simple to plug in the at86rf230 using SPI. Supporting USB
> sticks lets you develop on a desktop PC.

Hmm. One can solder (e.g.) the FTDI 2232 together with AT86RF230/231
and use that combo
instead of RazorUSB sticks.

> freaklabs.org is using ATAVRRZUSBSTICK

I'll look for the interface they are using to control sticks and check
how easy will it be to
write a driver for it.
-- 
With best wishes
Dmitry
