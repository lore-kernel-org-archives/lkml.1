Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZG0PGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZG0PGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZG0PGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:06:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36806
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbZG0PGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:06:11 -0400
Date: Mon, 27 Jul 2009 08:06:17 -0700 (PDT)
Message-Id: <20090727.080617.30802851.davem@davemloft.net>
To: keil@b1-systems.de
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907271121.34348.keil@b1-systems.de>
References: <20090727175328.fe3197a5.sfr@canb.auug.org.au>
	<200907271121.34348.keil@b1-systems.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <keil@b1-systems.de>
Date: Mon, 27 Jul 2009 11:21:33 +0200

> On Montag, 27. Juli 2009 09:53:28 you wrote:
>> Hi Dave,
>>
>> Today's linux-next build (powerpc allyesconfig) failed like this:
>>
>> drivers/isdn/hisax/built-in.o: In function `setup_w6692':
>> (.opd+0x4a28): multiple definition of `setup_w6692'
>> drivers/isdn/hardware/built-in.o:(.opd+0x4e90): first defined here
>> drivers/isdn/hisax/built-in.o: In function `.setup_w6692':
>> (.devinit.text+0x5b14): multiple definition of `.setup_w6692'
>> drivers/isdn/hardware/built-in.o:(.text+0x8b75c): first defined here
>>
>> Caused by commit 707b2ce6c1f4f1261788f2ff09ad82c35e0e6240
>> ("mISDN: Add driver for Winbond cards").
>>
>> setup_w6692 appears in drivers/isdn/hardware/mISDN/w6692.c and
>> drivers/isdn/hisax/w6692.c.  I applied the patch below for today (this
>> may not be correct).
>>
> 
> Sorry for that, yes this fix is correct - I really should test allyesconfig 
> more times by myself  :-(.
> 
> ACK.

Applied.
