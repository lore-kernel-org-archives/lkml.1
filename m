Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbXHSM4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbXHSM4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXHSM4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:56:36 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:51806 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbXHSM4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:56:35 -0400
Date: Sun, 19 Aug 2007 21:57:51 +0900 (JST)
Message-Id: <20070819.215751.25908715.anemo@mba.ocn.ne.jp>
To: kay.sievers@vrfy.org
Cc: david-b@pacbell.net, jengelh@computergmbh.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       greg@kroah.com
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <3ae72650708170932y5369213bq3479708216923edb@mail.gmail.com>
References: <200708170902.01260.david-b@pacbell.net>
	<20070818.011501.41012303.anemo@mba.ocn.ne.jp>
	<3ae72650708170932y5369213bq3479708216923edb@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 18:32:19 +0200, "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> > I guess there are some out-of-tree users of this driver, but fixing
> > them is really trivial, so I don't think this is a big compatibility
> > problem.
> 
> Again, the only sane solution is to provide MODALIAS="platform:<name>"
> from the platform bus, and adding the aliases to drivers who support
> autoloading. Modalias strings are not free-text strings, they are
> required to be prefixed by the subsystem.

I guess your objection is to my usage of MODULE_ALIAS, right?

I will send a patch to change the driver name string, because I did
not use the different name intentionally, I just had not thought about
hotplugging at all.  I think there is no serious reason to stick with
current driver name anyway.

---
Atsushi Nemoto
