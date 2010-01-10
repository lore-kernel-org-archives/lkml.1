Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109Ab0AJWMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0AJWMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070Ab0AJWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:12:20 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:34066 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754047Ab0AJWMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:12:19 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: Yinghai Lu <yinghai@kernel.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>, "H. Peter Anvin" <hpa@zytor.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Memory probing fails after 2.6.30 (bisected)
In-reply-to: <86802c441001091503j7da9a5c4s64af67095bbef095@mail.gmail.com>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> <86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com> <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org> <4B43BAEB.7070308@kernel.org> <20100108140419.88E1533C5F9@tippex.mynet.homeunix.org> <86802c441001091503j7da9a5c4s64af67095bbef095@mail.gmail.com>
Comments: In-reply-to Yinghai Lu <yinghai@kernel.org>
   message dated "Sat, 09 Jan 2010 15:03:30 -0800."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 10 Jan 2010 23:06:16 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100110220616.BC72C33C5FF@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NU5zk-0001Jb-82.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1NU5zk-0001Jb-82 0c1b2e59605493c493c9bcee43f88313
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> bca23db: x86, setup: revert ACPI 3 E820 extended attributes support
>> df7699c: x86, setup: "glove box" BIOS interrupts in the core boot code
>> cd67059: x86, setup: guard against pre-ACPI 3 e820 code not updating %ecx
>> c549e71: x86, setup: ACPI 3, BIOS workaround for E820-probing code
>
yinghai@kernel.org said:
> so it mean bca23db the reverting for c49e71 etc is not right? 

Well it seems so. I guess some of that stuff might be unguilty, though.
'git revert' was unhappy about doing them out of order. If you can carve them 
up in testable pieces, I'd be happy to do that.

-A

