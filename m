Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbZE1Ne2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbZE1Ne2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbZE1NeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:34:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:45245 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZE1NeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <20090528063445.GA12004@pengutronix.de>
References: <87vdnm8sec.fsf@macbook.be.48ers.dk> <20090527175609.GB31861@flint.arm.linux.org.uk> 
	<4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> 
	<20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> 
	<fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com> 
	<20090527235704.GQ6805@pengutronix.de> <fa686aa40905272021w18a148caqd2b73c4448da2b28@mail.gmail.com> 
	<20090528063445.GA12004@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 07:34:02 -0600
Message-ID: <fa686aa40905280634m153ff338j5791a22dba3ad790@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 12:34 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
>> It is inherent in the value "atmel,24c08".  Because the exact device
>> model is specified, the kernel can know what the page size and flags
>> are for that device.
>
> I am afraid this is not the case. I remember that we once had two revisions of
> the same eeprom, and the vendor decided to increase the page size without
> changing the naming of the eeprom. (Can't point to any documentation yet, would
> have to dig this up.) Those eeproms can be really weird.
>
> Also, there are _a lot_ of eeprom manufacturers out there, so the match table
> will be enormous....

... which is the whole point of "compatible".  Every possible variant
doesn't get listed in the device driver; device nodes in the tree
claim compatibility with older, already known parts.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
