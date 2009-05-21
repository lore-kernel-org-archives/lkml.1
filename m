Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZEUUdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZEUUdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZEUUdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:33:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34410
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081AbZEUUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:33:06 -0400
Date: Thu, 21 May 2009 13:33:04 -0700 (PDT)
Message-Id: <20090521.133304.10307675.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-hotplug@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       fenlason@redhat.com
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d"
 as interface name
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A15B5FE.3070207@s5r6.in-berlin.de>
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de>
	<20090521.123403.13286908.davem@davemloft.net>
	<4A15B5FE.3070207@s5r6.in-berlin.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Thu, 21 May 2009 22:13:50 +0200

> But I mildly disagree with the notion that the kernel can't start off
> with more qualification of the names than merely ensuring their
> uniqueness.  Or the other way around: Even an entirely meaningless
> prefix would be better than "eth..", or no prefix if that's possible,
> because eth suspiciously sounds like Ethernet with which the misnamed
> RFC 2734 driver eth1394 has very little to do.

Even the driver source file is named "ethXXX"!  All of the macros
in the driver are named ETH*.  The eth1394hdr looks eerily similar
to a real ethernet header except that it lacks a source MAC
address.  It's addressing information plus a 16-bit (wow, why that
size huh?) protocol field.  A lot like ethernet.

At the very least, it's related and similar.  So there is really
nothing inappropriate about eth* naming.

> However, how mild my disagreement is should be apparent from the fact
> that I didn't bother to suggest changing it before now, in 2009. :-)

You have more to lose by changing this now (breaking existing systems,
and yes I did see the hack workaround you posted) instead of fixing
userspace to make whatever indications you deem appropriate.
