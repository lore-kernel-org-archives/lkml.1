Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZE1J5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZE1J5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZE1J5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:57:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58891
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbZE1J5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:57:40 -0400
Date: Thu, 28 May 2009 02:57:39 -0700 (PDT)
Message-Id: <20090528.025739.16559619.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: benh@kernel.crashing.org, scottwood@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       timur@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090528091513.GA14789@n2100.arm.linux.org.uk>
References: <20090527175609.GB31861@flint.arm.linux.org.uk>
	<1243496236.3171.140.camel@pasglop>
	<20090528091513.GA14789@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Thu, 28 May 2009 10:15:13 +0100

> For example, how would an IrDA transceiver be expressed in OF?

As a child device node of the IRDA device, with associated
properties.

You can express _ANYTHING_ using the OF device tree.  It is
not even something to discuss, it's flexible enough.
