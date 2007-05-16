Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbXEPLhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbXEPLhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbXEPLhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:37:03 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52851 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761015AbXEPLhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:37:01 -0400
X-Sasl-enc: yNWvmljAv88wuBTbreMR2mGnKo9kT+GpU+dEY7Z/7yzY 1179315420
Message-ID: <464AEC76.7090000@whitby.id.au>
Date: Wed, 16 May 2007 21:05:18 +0930
From: Rod Whitby <rod@whitby.id.au>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
       Michael Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
References: <464034CF.20700@wpkg.org> <20070516071300.GB14222@infradead.org> <20070516094100.GB16262@xi.wantstofly.org> <464AE10E.7090606@whitby.id.au> <20070516105626.GC16262@xi.wantstofly.org>
In-Reply-To: <20070516105626.GC16262@xi.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek wrote:
> On Wed, May 16, 2007 at 08:16:38PM +0930, Rod Whitby wrote:
>> So, if the author of these patches wishes to concentrate on big-endian
>> support first, then we will not say (and have not said) anything which
>> will block inclusion of a big-endian only version of this driver.
> 
> The NSLU2 people are the ones here that are saying that the driver
> should really support LE (because that is what they happen to be
> using, the rest of the world runs the ixp4xx in BE)

I'll repeat again.  NSLU2-Linux supports both BE and LE.  We have about
5,000 users running BE and about 5,000 users running LE.  Perhaps you're
confusing the NSLU2-Linux project (which official supports both endians
equally) with the Debian project (which official supports only LE, and
has an unofficial BE port).

One NSLU2-Linux person said they would prefer the driver to support LE,
but would be happy for it to be marked BE only in the Kconfig as an
alternative.  That is consistent with what I wrote in my message.

> Please just write the patch and let's get this over with.

Please let's just stop arguing about it.  If a patch appears before it
gets merged, then great.  If it doesn't then it will appear at a later date.

-- Rod
