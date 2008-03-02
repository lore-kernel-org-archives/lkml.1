Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYCBMUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYCBMUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 07:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYCBMUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 07:20:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:29592 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYCBMUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 07:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AAT0iWECzx6kDbU5GUuqjxnxPEOkPMScXGvIGeyy1WguOyNDWh4GhxKiWSne0k7tnoRiW2DgkmFx9s/u5F7TjGxiWQLVxkVvfs1O9mA8MmR+ztt6uPcnOJ8RXhDbSDX4+L7+qGQYhbPWkEkSvliWf9FZ9ZJi5u3HJhtpYSuQbPQ=
Message-ID: <3d8471ca0803020420ka42319bu1b9888217c869d9d@mail.gmail.com>
Date: Sun, 2 Mar 2008 13:20:12 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2054 tcp_mark_head_lost()
Cc: "Giangiacomo Mariotti" <giangiacomo_mariotti@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802281018480.32401@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <858077.97160.qm@web39709.mail.mud.yahoo.com>
	 <20080223000310.4630daa8.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0802271108290.13029@kivilampi-30.cs.helsinki.fi>
	 <3d8471ca0802271056l320a7ee2m5227e114a968d483@mail.gmail.com>
	 <Pine.LNX.4.64.0802272120430.1741@kivilampi-30.cs.helsinki.fi>
	 <Pine.LNX.4.64.0802281018480.32401@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m22CLAnq030478

On Thu, Feb 28, 2008 at 9:22 AM, Ilpo JÃ¤rvinen<ilpo.jarvinen@helsinki.fi> wrote:>  [PATCH] TCP debug S+L (for 2.6.25-rcs, incompatible with 2.6.24.y)
Bittorrenting with this patch applied floods my dmesg. Here is a log dump:
http://guichaz.free.fr/tcp-debug.log.bz2 (2.3M compressed, 113M uncompressed)
It does not contain any "KERNEL: assertion (packets <=tp->packets_out) failed at" line, so I'm afraid it's just noise.
Cheers.
-- Guillaumeÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
