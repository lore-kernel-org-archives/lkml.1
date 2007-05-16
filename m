Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbXEPKsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbXEPKsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 06:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbXEPKs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 06:48:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35064 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755169AbXEPKs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 06:48:27 -0400
X-Sasl-enc: LSNB8r144nQPQDHat5O0/3trsYH4K8jNBp0n6+U4WIzD 1179312505
Message-ID: <464AE10E.7090606@whitby.id.au>
Date: Wed, 16 May 2007 20:16:38 +0930
From: Rod Whitby <rod@whitby.id.au>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
       Michael Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
References: <464034CF.20700@wpkg.org> <20070516071300.GB14222@infradead.org> <20070516094100.GB16262@xi.wantstofly.org>
In-Reply-To: <20070516094100.GB16262@xi.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of people wrote:
> Lots of huffing and puffing about endian support by this driver ...

For what it's worth, the NSLU2-Linux project (which has over 10,000
known users of our custom ixp4xx firmware, most of which will eventually
be users of this new driver) is *endian-neutral*.

We support both big-endian and little-endian usage of the ixp4xx in a
number of consumer devices like the NSLU2, NAS100d, DSMG600, and FSG3.

We are very interested in getting this driver into mainline in the most
expedient and correct fashion acceptable to the relevant mainline
maintainers.  We have also discussed this situation with the author of
the previous set of ixp4xx open-source ethernet driver patches, and he
also recommends that we put our support behind this new set of patches.

So, if the author of these patches wishes to concentrate on big-endian
support first, then we will not say (and have not said) anything which
will block inclusion of a big-endian only version of this driver.

In parallel to this initial upstream push, we will be working with the
author to make sure that this driver supports little-endian devices as
well (as we are endian-neutral in our project's support of consumer
devices based on the ixp4xx).  If we get this done before upstream
acceptance of the big-endian version, that will be great.  If we don't,
then we'll work to hit the next merge window.  We will create a
functionally correct little-endian version first (the simple
byte-swapping implementation) and will work on a performance-enhanced
version later (if that is even possible without prohibitive massive
upstream changes).

There simply is no reason for everyone to be arguing about this.

Remember that what we are seeing here is an open-source replacement for
a long-time proprietary driver.  We should all rejoice in that, support
the author of these patches, and not fight amongst ourselves.

-- Rod Whitby
-- NSLU2-Linux Project Lead

