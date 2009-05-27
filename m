Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZE0U2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZE0U2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbZE0U23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:28:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57331
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbZE0U22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:28:28 -0400
Date: Wed, 27 May 2009 13:28:27 -0700 (PDT)
Message-Id: <20090527.132827.65331718.davem@davemloft.net>
To: plagnioj@jcrosoft.com
Cc: linux@arm.linux.org.uk, jonsmirl@gmail.com, scottwood@freescale.com,
       jacmet@sunsite.dk, r.schwebel@pengutronix.de,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, yuan-bo.ye@motorola.com,
       timur@freescale.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090527193927.GD30039@game.jcrosoft.org>
References: <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com>
	<20090527192116.GA31110@n2100.arm.linux.org.uk>
	<20090527193927.GD30039@game.jcrosoft.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date: Wed, 27 May 2009 21:39:27 +0200

> when you have to support the same driver for non OF and OF platform it's
> really a pain in the ass

We could embed the platform_device object into the of_platform_device
structure, it's just an implementation issue.

But more to the point, I can tell you that anything platform_device
does can be implemented in terms of of_platform_device but the
opposite is not true.

Actually, I kind of appreciate the existence of both kinds of objects.
When you're instantiating LEDs or similar small devices on a MDIO
bus, and the LED driver has to work on OF and non-OF platforms,
I see nothing wrong with using platform devices for instantiation.
And I've done this myself for system LED devices on sparc64 boxes.
