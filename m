Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZLUOsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZLUOsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZLUOsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:48:35 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39310 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLUOsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:48:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R2k29KdUgz5L+N3jwkEjhgqk9KN36HkVVx/jlrH3Tj/2qpfYX+bwjMQrbrn8SpNW1B
         ldXAuov6B+PCH34f4/xi0IgOUKgWkm82yBI/m7gFV5qFPvdZw2x99V8uSJ6QGSwCOi6m
         rmISK3Iq7cOO+KulKWAmvq34NQdiutizEuY8k=
MIME-Version: 1.0
In-Reply-To: <200912210204.08583.rob@landley.net>
References: <200912202342.16806.rob@landley.net>
	 <73c1f2160912202306y8e3e394mb3b4ddcf24caacc1@mail.gmail.com>
	 <200912210204.08583.rob@landley.net>
Date: Mon, 21 Dec 2009 09:48:31 -0500
Message-ID: <73c1f2160912210648j2a8790b6ue611503ef931a77b@mail.gmail.com>
Subject: Re: Why is ARCH m68k hardwired into drivers/net/wan/Makefile?
From: Brian Gerst <brgerst@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 3:04 AM, Rob Landley <rob@landley.net> wrote:
> On Monday 21 December 2009 01:06:38 Brian Gerst wrote:
>> On Mon, Dec 21, 2009 at 12:42 AM, Rob Landley <rob@landley.net> wrote:
>> > Anyone have an opinion on this?
>> >
>> > From drivers/net/wan/Makefile:
>> >>ifeq ($(ARCH),m68k)
>> >>  AS68K = $(AS)
>> >>  LD68K = $(LD)
>> >>else
>> >>  AS68K = as68k
>> >>  LD68K = ld68k
>> >>endif
>>
>> Looks like it's to build firmware to run on the card.
>
> Sure, I'm just wondering why such obvious arch-specific code is outside the
> arch/m68k directory.
>
> In theory, when you're building for m68k, you supply appropriate AS and LD
> values already (or the rest of the kernel won't build).  If you're not
> building for m68k and this driver only supports m68k, then the config should
> prevent you from selecting it.  So why is on earth is architecture-specific
> tool selection being done in drivers/net/wan?

The m68k processor that this firmware is being built for is embedded
on the device, not the main system cpu.  You can have one of these
cards on any system, not just m68k.

PS. always CC the list with replies.

--
Brian Gerst
