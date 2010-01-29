Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553Ab0A2L0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0A2L0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017Ab0A2L0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:26:37 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:51921 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab0A2L0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:26:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ezFOnN/mhuE/JpbhxHZbyQbs0FGB5jgVEuG8Rfz9onAiT+cHOutmwyJ0H1JII+VquJ
         ezeZ1vcf3vq7F6ip/oZuaxp4iwzZlR0PMyAqXQtT3BfjWezDqGf6zEThVXqLUcH8gtA4
         4MptrW4FQv34aYv18EhYQ+DhYuCtdSmBdq6kE=
MIME-Version: 1.0
In-Reply-To: <20100128220835.GA23471@n2100.arm.linux.org.uk>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
	 <20100128124038.8982.82995.sendpatchset@rxone.opensource.se>
	 <20100128220835.GA23471@n2100.arm.linux.org.uk>
Date: Fri, 29 Jan 2010 20:26:34 +0900
Message-ID: <aec7e5c31001290326q76036a49p44fe5a5b31f5cd53@mail.gmail.com>
Subject: Re: [PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
From: Magnus Damm <magnus.damm@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 7:08 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> The entries in this choice menu are sorted by option text - please
> place your new option appropriately to avoid conflicts.

Ok, will make sure it gets sorted properly.

>> +static struct sh_timer_config cmt10_platform_data = {
>> +     .name = "CMT10",
>> +     .channel_offset = 0x10,
>> +     .timer_bit = 0,
>> +     .clk = "r_clk",
>
> I guess you can't do a lot about this because of arch/sh, but over in ARM
> land, we use clkdev to get the clock primerily by the device name rather
> than a string passed around; this is how the clk API is meant to be used.

At this early stage there is not so much to do. When I get around to
implement the clock framework and runtime pm for SuperH Mobile ARM
then I'll have a close look at clkdev.

I'll update and resend these patches next week.

Thanks!

/ magnus
