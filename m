Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZD0LST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZD0LST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZD0LSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:18:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:26370 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZD0LSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PTTcs7xCH6+W5TnepgrKx9eJu/AD1HKNqDfn7HAAWDH0acLAGIzTR2I+JifD12RBZT
         kKNjDf4/L5n3aUM2YgbbXXTSvVmiWYN8BdbNP9yK1CuSxuYh0pRht1Mollh+deeKPyg0
         UeCvsG0nNvw4IG4xW3gJM+qLEGQVgxxlLcRpo=
MIME-Version: 1.0
In-Reply-To: <1240821139-7247-11-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
Date: Mon, 27 Apr 2009 13:18:03 +0200
X-Google-Sender-Auth: d75cce907e896025
Message-ID: <10f740e80904270418l77c499a6te4df4c05a333311e@mail.gmail.com>
Subject: Re: [PATCH 10/30] microblaze_mmu_v1: Context handling - 
	mmu_context.c/h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:31,  <monstr@monstr.eu> wrote:
> --- a/arch/microblaze/include/asm/mmu_context.h
> +++ b/arch/microblaze/include/asm/mmu_context.h

> +/*
> + * This function defines the mapping from contexts to VSIDs (virtual
> + * segment IDs).  We use a skew on both the context and the high 4 bits
> + * of the 32-bit virtual address (the "effective segment ID") in order
> + * to spread out the entries in the MMU hash table.  Note, if this
> + * function is changed then arch/ppc/mm/hashtable.S will have to be
                                    ^^^

> + * changed to correspond.
> + */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
