Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbZLJKBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbZLJKBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbZLJKBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:01:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42842 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZLJKBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cA/1Jf2+TEnE/BTjKMnF+vckR9vRR3+9MTSKlo87ExmZrZ9ZRAlZ3Ovs+b22g1TQZ/
         SACJAqcIlE70DS85Bz3fMp0im/F0YwutGXhXEXo+atoIPaz74iBzX0C4TZfkUzTMbt+P
         Z6Mz4VKj/j5RyFQ6t99cmT/Pu1TrBjjr4lXG0=
MIME-Version: 1.0
In-Reply-To: <4B2042FA.8080406@lougher.demon.co.uk>
References: <E1NHTHg-0001sM-NQ@dylan.lougher.demon.co.uk>
	 <20091207145705.cd30cae8.akpm@linux-foundation.org>
	 <4B1ED122.3040309@lougher.demon.co.uk>
	 <1260352852.19669.1253.camel@localhost>
	 <4B2042FA.8080406@lougher.demon.co.uk>
Date: Thu, 10 Dec 2009 11:01:23 +0100
X-Google-Sender-Auth: aa466dcc522785af
Message-ID: <10f740e80912100201l6d83588evff46e95ec96d0aed@mail.gmail.com>
Subject: Re: [PATCH 1/9] Squashfs: move zlib decompression wrapper code into a 
	separate file
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: dedekind1@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       Tim Bird <tim.bird@am.sony.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

On Thu, Dec 10, 2009 at 01:38, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
> Artem Bityutskiy wrote:
>>
>> Did you consider using cryptoapi? UBIFS uses zlib/lzo in cryptoapi - it
>> is a very clean way.

Exactly my question, as that's why the Crypto API was extended with
support for partial (de)compression in the first place ;-)

In addition, using the Crypto API has the advantage that Squashfs will
use hardware decompression if/when available.

> Yes I did consider using the cryptoapi, but this doesn't have support for
> lzma in mainline.

IIRC, Felix Fietkau added support for that for OpenWRT...

> My aim is add lzma filesystem support to Squashfs using the existing kernel
> lzma iplementation, and to make as few changes to that as necessary.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
