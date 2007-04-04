Return-Path: <linux-kernel-owner+w=401wt.eu-S966265AbXDDBr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966265AbXDDBr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966264AbXDDBr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:47:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50169
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966262AbXDDBr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:47:27 -0400
Date: Tue, 03 Apr 2007 18:47:27 -0700 (PDT)
Message-Id: <20070403.184727.26533881.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: paulus@samba.org, dwmw2@infradead.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070404023637.65c56227@the-village.bc.nu>
References: <20070404021924.71e87580@the-village.bc.nu>
	<20070403.182125.77058566.davem@davemloft.net>
	<20070404023637.65c56227@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 4 Apr 2007 02:36:37 +0100

> I've no fundamental problem with S0->console port 1, S1 -> console port 2
> etc, but the general notion that type and positional information doesn't
> matter is complete and utter bollocks when you try and apply it to any
> serious serial setup.

If you want geographical type device specification hierarchies, to
sanely manage that kind of stuff, they belong via sysfs or something
userside like that.

Using a bunch of different majors does not help the situation you
speak of.

What if I have 1,000 cyclades cards in my system?  The cyclades
serial major number helps me diddly in that case.  What about
having 82 8250's?
