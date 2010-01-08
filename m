Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462Ab0AHOF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0AHOF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 09:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442Ab0AHOF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 09:05:58 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:56986 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675Ab0AHOF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 09:05:57 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: Yinghai Lu <yinghai@kernel.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Memory probing fails after 2.6.30 (bisected)
In-reply-to: <4B43BAEB.7070308@kernel.org>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> <86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com> <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org> <4B43BAEB.7070308@kernel.org>
Comments: In-reply-to Yinghai Lu <yinghai@kernel.org>
   message dated "Tue, 05 Jan 2010 14:19:23 -0800."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 08 Jan 2010 15:04:19 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100108140419.88E1533C5F9@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NTFTO-0001in-AW.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1NTFTO-0001in-AW 6d9bdc648553db087da847e789011885
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Success!

yinghai@kernel.org said:
> can you try to revert some e820 detect patch?
>
> bca23db: x86, setup: revert ACPI 3 E820 extended attributes support 
> df7699c: x86, setup: "glove box" BIOS interrupts in the core boot code 
> cd67059: x86, setup: guard against pre-ACPI 3 e820 code not updating %ecx 
> c549e71: x86, setup: ACPI 3, BIOS workaround for E820-probing code

Starting at 33-rc3, reverting the above 4 commits cumulatively, brings back my 
e820 table.

I have no idea how to fix c549e71 so it don't break on my system.

This is a hp nc6400 laptop, btw.



