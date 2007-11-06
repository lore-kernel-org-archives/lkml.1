Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbXKFSDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbXKFSDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXKFSDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:03:22 -0500
Received: from khc.piap.pl ([195.187.100.11]:47727 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXKFSDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:03:21 -0500
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>,
       djohnson+linux-kernel@sw.starentnetworks.com, jes@trained-monkey.org,
       mchan@broadcom.com, ram.vepa@neterion.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bguo@sw.starentnetworks.com
Subject: Re: [PATCH 1/2] NET: Re-add VLAN tag for devices incapable of keeping it
References: <472A6089.7020104@hp.com>
	<18223.22291.622615.129374@zeus.sw.starentnetworks.com>
	<472F5A33.20906@trash.net>
	<20071105.151544.175839612.davem@davemloft.net>
	<472FB375.1020802@trash.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 06 Nov 2007 19:03:17 +0100
In-Reply-To: <472FB375.1020802@trash.net> (Patrick McHardy's message of "Tue, 06 Nov 2007 01:21:09 +0100")
Message-ID: <m3y7db45ga.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> I think there is one more case that matters, which is briding
> from a device with VLAN stripping for a VLAN not configured
> locally. The tag will be stripped and will be lost for forwarded
> packets.

I think we should drop such packets on RX. Anyway we shouldn't
forward them.
-- 
Krzysztof Halasa
