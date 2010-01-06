Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884Ab0AFOfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0AFOfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 09:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867Ab0AFOfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 09:35:54 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:37144 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854Ab0AFOfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 09:35:53 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
cc: linux-kernel@vger.kernel.org, awalls@radix.net,
       linux-pm@lists.linux-foundation.org,
       =?UTF-8?Q?Anders_Eriksson?= <aeriksson@fastmail.fm>,
       danborkmann@googlemail.com
Subject: Re: [linux-pm] =?utf-8?q?=5Bsuspend/resume=5D_Re=3A_userspace_notific?= =?utf-8?q?ation_from_module?=
In-reply-to: <1ab86ec9.7bc73105.4b43cd45.c2747@o2.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001052223.21964.rjw@sisk.pl> <16a1b165.2fdc37c6.4b43b943.c6733@o2.pl> <201001060003.23419.rjw@sisk.pl> <1ab86ec9.7bc73105.4b43cd45.c2747@o2.pl>
Comments: In-reply-to =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
   message dated "Wed, 06 Jan 2010 00:37:41 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 06 Jan 2010 15:35:34 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100106143534.A7EEA33C5F5@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NSWzC-0000vE-B5.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1NSWzC-0000vE-B5 1f5efaab1f071ee7760e2791bce21361
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uzi18@o2.pl said:
>  Ummm sorry, it's IM App, to be realible for such app it's needed to close
> conn before suspend, because after resume tcp connections will wait
> (especialy on linux) quiet a lot of time to broke and reconnect.

I don't know the details here, but shouldn't the kernel fix this internally?

If sufficient time have elapsed so the kernel _should_ have sent keep alives 
etc on an othervise idle connection, they shold be sent immediately on resume. 
If the other end has disappeared by then, the resulting port unreachable 
should trigger a local closure of the tcp state which the app will notice 
(EBADF, or similar). Or?

Seems to me the kernel should sit on enough info to handle this nicely. 


