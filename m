Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbYAUQNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbYAUQNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758342AbYAUQNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:13:30 -0500
Received: from bossdog.realss.com ([211.157.108.128]:44028 "EHLO
	bossdog.realss.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbYAUQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:13:29 -0500
Subject: Re: Huawei EC321 CDMA PCCARD support broken
From: =?UTF-8?Q?=E5=BC=A0=E9=9F=A1=E6=AD=A6?= <zhangweiwu@realss.com>
To: linux-kernel@vger.kernel.org
Cc: smurf@smurf.noris.de, hugh@blemings.org
In-Reply-To: <1199753931.6093.7.camel@Cruella>
References: <1199753931.6093.7.camel@Cruella>
Content-Type: text/plain; charset=utf-8
Organization: Real Softservice
Date: Tue, 22 Jan 2008 00:04:57 +0800
Message-Id: <1200931498.6038.2.camel@Cruella>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2008-01-08二的 08:58 +0800，张韡武写道：
> Dear all
> 
> A lot of google searches reflect that, the latest kernel supporting
> Huawei EC321 CDMA PCCARD is 2.6.17. My version (2.6.22-14 on Ubuntu)
> doesn't work.

This is not true, the "google searches" result turns to be of a
completely not related issue.

Sorry I made a mistake in my previous posting. The Huawei EC321 CDMA
card works just fine with the kernel I am using: 2.6.22

I mis-reported the problem because, unlike the other card I used before
(Bora), it seems to me this card have some 'wake-up' time. It start to
work several minutes after it's inserted to the slot. I also read other
posts on Chinese forums mentioned this delay time.

If user tries to dial right after inserted the card, he would see the
behavior I described in previous posts. If he waits longer the
connection establish. Here is the wvdial.conf I used to establish a
connection (tested working):

[Dialer Defaults]
Phone = #777
Username = CARD
Password = CARD
Modem = /dev/ttyUSB0

Very simple.

I totally looked in the wrong direction (looking for difference in
kernel version and option.c). All I had to do is to wait a bit.


