Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475Ab0ATLAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0ATLAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 06:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666Ab0ATLAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 06:00:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34222 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0ATLAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 06:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A/OEgFtbLGFYI0bh8jp/jKS0M3YvdaBJE16b2DJjn1VeZgIgP3OrldaRK7TsBh6rSW
         HAEdxrnbOhhgIVlTSavkC+X69ZgUN9WoKia8YzomnOnIvQOfZETHayO5RpBaEWsacjli
         nrbABtHbWvhizO9j34X4lubYMnC4oz22zZRto=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1001200248x1a4b3cedoae90b4f1495d2358@mail.gmail.com>
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
	 <1263982111-24123-2-git-send-email-monstr@monstr.eu>
	 <b6fcc0a1001200248x1a4b3cedoae90b4f1495d2358@mail.gmail.com>
Date: Wed, 20 Jan 2010 12:00:31 +0100
X-Google-Sender-Auth: 2392f3d805644afb
Message-ID: <10f740e81001200300o217b955fqb79d5628b2e62731@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: dma: Add BUG_ON for uninitialized dma_ops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       arnd@arndb.de, linux-arch@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, mingo@elte.hu,
       joerg.roedel@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 11:48, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Wed, Jan 20, 2010 at 12:08 PM,  <monstr@monstr.eu> wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>> Check that dma_ops are initialized correctly. Without this
>> checking you get kernel fault and you don't know where the problem is.
>
> Oh, yes you do. PC will be of some small value.

And the backtrace will tell you where to look...

>> +       BUG_ON(!ops);
>>        BUG_ON(!valid_dma_direction(dir));
>>        addr = ops->map_page(dev, virt_to_page(ptr),

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
