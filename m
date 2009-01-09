Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbZAIWEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbZAIWEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbZAIWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:04:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35914
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757796AbZAIWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:04:22 -0500
Date: Fri, 09 Jan 2009 14:04:22 -0800 (PST)
Message-Id: <20090109.140422.60087297.davem@davemloft.net>
To: alessandro.suardi@gmail.com
Cc: jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, dwmw2@infradead.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
References: <5a4c581d0901081233y6b546167sbe3ed9f2ea37f1f9@mail.gmail.com>
	<20090108.125331.03608787.davem@davemloft.net>
	<5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Date: Fri, 9 Jan 2009 18:30:40 +0100

> Clearly the requirement changed in -git8, AFAICS.

Because -git8 is where the firmware requirement got added.

If you build the TG3 driver statically into your kernel,
the only way to get the firmware properly loaded is to
enable that CONFIG_FIRMWARE_IN_KERNEL option.

Your filesystem isn't mounted when the driver initializes
in that case, therefore there is no way to get at the
firwware that might be present there.
