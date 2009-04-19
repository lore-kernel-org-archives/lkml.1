Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZDSEP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZDSEP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbZDSEPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:15:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36729
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbZDSEPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:15:12 -0400
Date: Sat, 18 Apr 2009 21:15:03 -0700 (PDT)
Message-Id: <20090418.211503.13481677.davem@davemloft.net>
To: g.liakhovetski@gmx.de
Cc: florian@openwrt.org, peter@holik.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0904182146220.14879@axis700.grange>
References: <Pine.LNX.4.64.0904172102300.5119@axis700.grange>
	<20090418.015541.05303908.davem@davemloft.net>
	<Pine.LNX.4.64.0904182146220.14879@axis700.grange>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Sat, 18 Apr 2009 21:54:11 +0200 (CEST)

> If you are working with that file and see a call to reg_write() you
> know where to look for it.

I would never use such a generic name for a driver local routine.

For example, in the tg3 driver we use "tr32()" and "tw32()" so that
at least some inkling of the driver name, even if it is just one
character, prefixes the name.

This extends to other driver's I've written.  The niu driver thus
uses "tr64()" and "nw64()".

This is just common sense as far as I'm concerned.  It is just
as straight forward as not using variable names like 'foo'.
