Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYKEEv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYKEEv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 23:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYKEEvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 23:51:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39598 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbYKEEvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 23:51:16 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial/8250: fix uninitialized warnings
Cc: kosaki.motohiro@jp.fujitsu.com, linux-serial@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081104174142.360a964a@lxorguk.ukuu.org.uk>
References: <20081105022353.7CB0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081104174142.360a964a@lxorguk.ukuu.org.uk>
Message-Id: <20081105135042.966B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  5 Nov 2008 13:51:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > fix following warnings.
> > 
> > drivers/serial/8250.c: In function ‘serial8250_shutdown’:
> > drivers/serial/8250.c:1612: warnings: ‘i’ may be used uninitialized in this function
> 
> NAK
> 
> This is an incorrect compiler warning. It's also one that current gcc
> does not emit warnings for.

I see.
Thanks!



