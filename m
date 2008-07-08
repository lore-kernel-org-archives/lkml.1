Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYGHI5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYGHI5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYGHI5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:57:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39243
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbYGHI5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:57:01 -0400
Date: Tue, 08 Jul 2008 01:57:01 -0700 (PDT)
Message-Id: <20080708.015701.249196626.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, dwmw2@infradead.org, andi@firstfloor.org, tytso@mit.edu,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080708073637.32037c76@the-village.bc.nu>
References: <20080707221427.163c4a30@the-village.bc.nu>
	<20080707.145819.209342070.davem@davemloft.net>
	<20080708073637.32037c76@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 8 Jul 2008 07:36:37 +0100

> > I can only see it being about separation, pure and simple.
> 
> Separation - of firmware that can be paged from code that cannot.

It can't be paged from the drivers we're talking about,
no matter how hard you try.

Every chip reset needs the firmware around so it can be
reloaded into the card.

This applies to tg3, bnx2, bnx2x, etc. etc. etc.

