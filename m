Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbZE1ACo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbZE1ACo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbZE1ACg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:02:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42604
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093AbZE1ACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:02:34 -0400
Date: Wed, 27 May 2009 17:02:34 -0700 (PDT)
Message-Id: <20090527.170234.69075052.davem@davemloft.net>
To: scottwood@freescale.com
Cc: r.schwebel@pengutronix.de, grant.likely@secretlab.ca,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, yuan-bo.ye@motorola.com,
       timur@freescale.com, rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A1DD3A0.3010501@freescale.com>
References: <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com>
	<20090527234801.GP6805@pengutronix.de>
	<4A1DD3A0.3010501@freescale.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Wood <scottwood@freescale.com>
Date: Wed, 27 May 2009 18:58:24 -0500

> Because it's better to have a little platform specific code than a lot
> of it?

Judging by some of the questions I see popping up over and over again,
I suspect that many people resisting OF device trees lack much of an
understanding of what they provide and can do.

Questions like "How do we determine attribute X of a given device" has
an obvious answer if you understand device node properties and that
you can encode arbitrary things into them to provide arbitrary bits of
information on a per-device-instance basis.
