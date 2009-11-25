Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZKYBxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZKYBxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbZKYBxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:53:35 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:41539 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155AbZKYBxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:53:34 -0500
MIME-Version: 1.0
In-Reply-To: <20091124170419.92cb63f6.akpm@linux-foundation.org>
References: <fa686aa40911241654w6ceb2c96nb3a6a57ac1b471f5@mail.gmail.com> 
	<20091124170419.92cb63f6.akpm@linux-foundation.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 24 Nov 2009 18:53:21 -0700
X-Google-Sender-Auth: 080d21e227c7aa5d
Message-ID: <fa686aa40911241753lca699c9sa9ca0a0585a9d39d@mail.gmail.com>
Subject: Re: [RFC] two new linux-next trees (SPI and devicetree)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michal Simek <michal.simek@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 6:04 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 24 Nov 2009 17:54:27 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> I've made the offer to be SPI
>> co-maintainer,
>
> OK by me.  Don't break anything.

I'll do my best.

> My current stash:
>
>
> atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch
> spi-controller-driver-for-designware-spi-core.patch
> spi-add-pci-interface-driver-for-designware-spi-core.patch
> spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
> spi-controller-driver-for-designware-spi-core-fix.patch
> spidev-add-proper-section-markers.patch
> spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
> spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
> spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
> spi_s3c24xx-add-fiq-pseudo-dma-support.patch

Since they're already in your tree, do you mind continuing to shepherd
these (either merge or drop)?  I've gotten a patchwork project set up
on kernel.org for the spi mailing list, so I can easily track things
from this point on.  My gameplan at this point is to try and stay on
top of the things that I'm familiar with (mostly powerpc) and depend
on other people to ack the rest.  I'll pick up anything that a)
doesn't look ugly, b) isn't contested, and c) applies.  :-)

>> but I haven't received any feedback yet from either
>> akpm or dbrownell.
>
> I haven't heard anything from David in over a month.

Okay, shall I go ahead and merge my change to MAINTAINERS through my
tree too then?

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
