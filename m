Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbZE1Fbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbZE1Fbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZE1Fbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:31:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56310
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbZE1Fbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:31:48 -0400
Date: Wed, 27 May 2009 22:31:47 -0700 (PDT)
Message-Id: <20090527.223147.94364683.davem@davemloft.net>
To: david@gibson.dropbear.id.au
Cc: linux@arm.linux.org.uk, jonsmirl@gmail.com, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, timur@freescale.com,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090528044732.GK1464@yookeroo.seuss>
References: <20090528025258.GB1464@yookeroo.seuss>
	<20090527.212730.183576278.davem@davemloft.net>
	<20090528044732.GK1464@yookeroo.seuss>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gibson <david@gibson.dropbear.id.au>
Date: Thu, 28 May 2009 14:47:32 +1000

> The conceptual problem becomes apparent when you consider things like
> i2c.  The devtree is the obvious source to discover what i2c device
> are present, but they need to be instantiated as i2c devices on the
> i2c bus, not of platform devices.

Sure, but there is no reason there can't be an of_platform driver
for those i2c devices.  And such instantiated devices get propagated
either instantly to the parent, or later when the parent controller
probes.
