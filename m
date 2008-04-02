Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbYDBHVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbYDBHVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYDBHVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:21:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40152 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYDBHVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:21:42 -0400
Message-ID: <47F332FA.9000603@yandex.ru>
Date: Wed, 02 Apr 2008 10:17:14 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <878wzx25s7.fsf@basil.nowhere.org> <47F21B47.4000206@yandex.ru> <47F26278.5070009@zytor.com> <20080401212652.GD23796@1wt.eu> <47F30FDD.5080003@yandex.ru> <20080402062543.GA5950@1wt.eu>
In-Reply-To: <20080402062543.GA5950@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Apr 2008 07:21:18.0353 (UTC) FILETIME=[24CBC810:01C89492]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> One of the problem is that unless you crash-test your flash cards, you will
> never know if their wear-leveling algorithm is fine or not. And I suspect
> that nowadays, due to very large consumer demand, flash cards price drop
> at the cost of reliability. I think that most of those not flagged
> "industrial-grade" do absolutely zero wear-leveling, because they are sold
> to people using them in digital cameras, and they will never kill their
> device with such a usage.

Sure, I know about this problem. My point was that in this case it is wiser
to use bare flash and put JFFS2 on it, instead of using this black box
MMC/etc and then put JFFS2 on it.

> I'm certainly not the only one with this requirement. A lot of embedded
> motherboards come with IDE compactflash connectors. This is very convenient,
> but if you need to keep informations between reboots, you have to write to
> the device anyway. If you need to do that very often, either you pray for
> the device to be very reliable, or you take all the chances on your side
> by adding your own wear-leveling "just in case".

OK. Fair enough. Although stuff exists, but this does not necessarily mean
this a good design :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
