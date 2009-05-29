Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbZE2ELR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbZE2ELR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 00:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZE2ELF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 00:11:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37837
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZE2ELD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 00:11:03 -0400
Date: Thu, 28 May 2009 21:11:03 -0700 (PDT)
Message-Id: <20090528.211103.226720983.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: wmb@firmworks.com, grant.likely@secretlab.ca, dbaryshkov@gmail.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243569136.17903.27.camel@pasglop>
References: <20090529013908.GA7831@yookeroo.seuss>
	<4A1F4189.8060702@firmworks.com>
	<1243569136.17903.27.camel@pasglop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 29 May 2009 13:52:16 +1000

> But it comes with some drawbacks too... too often, this stuff will
> replace good documentation, the scripts provided by the FW will be
> busted in subtle ways that the kernel will have to work around, and thus
> it can be used as a way to avoid documenting or open sourcing things and
> obfuscating operations.

We'll have all of the down sides of ACPI if we start doing stuff
like this.

Keep FCODE execution in the firmware itself, thanks.
