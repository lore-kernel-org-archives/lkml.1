Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667Ab0AIXDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0AIXDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381Ab0AIXDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:03:31 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61229 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0AIXDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eo2j1mS7JYPHI2LTy5s8ymDFVeSde83eVyivBsY5Y+jYXi1Q9EaHoK685B2cPGFQLi
         l0eaJTlrG7JBFyxq8WlW2f2hqbpD8lnGF/kI2LmHIMnnEYfUzxIRvKplZLToDjtrxLyU
         PszNYaqf0DCQ+TfJrkctdHzDhXCEKoeYPORrI=
MIME-Version: 1.0
In-Reply-To: <20100108140419.88E1533C5F9@tippex.mynet.homeunix.org>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org>
	 <86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com>
	 <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org>
	 <4B43BAEB.7070308@kernel.org>
	 <20100108140419.88E1533C5F9@tippex.mynet.homeunix.org>
Date: Sat, 9 Jan 2010 15:03:30 -0800
X-Google-Sender-Auth: 6488f95a32d25a55
Message-ID: <86802c441001091503j7da9a5c4s64af67095bbef095@mail.gmail.com>
Subject: Re: Memory probing fails after 2.6.30 (bisected)
From: Yinghai Lu <yinghai@kernel.org>
To: Anders Eriksson <aeriksson@fastmail.fm>, "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 6:04 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>
> Success!
>
> yinghai@kernel.org said:
>> can you try to revert some e820 detect patch?
>>
>> bca23db: x86, setup: revert ACPI 3 E820 extended attributes support
>> df7699c: x86, setup: "glove box" BIOS interrupts in the core boot code
>> cd67059: x86, setup: guard against pre-ACPI 3 e820 code not updating %ecx
>> c549e71: x86, setup: ACPI 3, BIOS workaround for E820-probing code
>
> Starting at 33-rc3, reverting the above 4 commits cumulatively, brings back my
> e820 table.
>
> I have no idea how to fix c549e71 so it don't break on my system.
>
> This is a hp nc6400 laptop, btw.

so it mean bca23db the reverting for c49e71 etc is not right?

YH
