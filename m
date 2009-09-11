Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZIKRWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZIKRWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZIKRWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:22:14 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:51212 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZIKRWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R/AEwesIfzVMojUsLO/rhLvwBq8B/FMm8GODlW9zZzQkhiK75Yb/ry+XpksDp9UJPx
         gYorxwheYvkx/ZJ6CloG7F1ibnoT1gE+9lWNeQ7s2ztonaNHMrC/drzeWL/XB52iNWO4
         wn5Toddm7N3QLc2REo3Pf0WbuiFrQ+Up7Dpuw=
MIME-Version: 1.0
In-Reply-To: <20090911150210.GB16593@kroah.com>
References: <10f740e80909110726x313e3e3coe2321c683163e3a5@mail.gmail.com>
	 <20090911150210.GB16593@kroah.com>
Date: Fri, 11 Sep 2009 19:22:16 +0200
X-Google-Sender-Auth: fa7931801b98d495
Message-ID: <10f740e80909111022t50d8beb9qf94cfd13413fb29e@mail.gmail.com>
Subject: Re: drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined 
	from 'boolean' to 'tristate'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@gefanuc.com>, linux-kernel@vger.kernel.org,
       Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 17:02, Greg KH<greg@kroah.com> wrote:
> On Fri, Sep 11, 2009 at 04:26:36PM +0200, Geert Uytterhoeven wrote:
>> http://kisskb.ellerman.id.au/kisskb/buildresult/1221192/:
>> drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from
>> 'boolean' to 'tristate'
>> drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from
>> 'boolean' to 'tristate'
>>
>> We already have:
>>
>> arch/m68k/Kconfig:config VME
>> arch/m68k/Kconfig:      bool "VME (Motorola and BVM) support"
>> arch/m68k/Kconfig:        Say Y here if you want to build a kernel for
>> a 680x0 based VME
>
> Ah, not good.
>
> Are these a board-specific thing?  It's not the "VME bus" is it?

These are to enable support for the original VME-based machines (VME
started it's life on m68k).

>From a historical point of view, it's a bit funny to see the new
CONFIG_VME(_BUS) depends on PCI ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
