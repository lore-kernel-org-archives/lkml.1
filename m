Return-Path: <linux-kernel-owner+w=401wt.eu-S934048AbZE0U04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbZE0U04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbZE0U0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:26:30 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:37436 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763938AbZE0U02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:26:28 -0400
Date: Wed, 27 May 2009 22:14:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527201445.GE30039@game.jcrosoft.org>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <4A1D9A1E.80603@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D9A1E.80603@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 11664041562050308926
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:53 Wed 27 May     , Scott Wood wrote:
> Russell King wrote:
>> On Wed, May 27, 2009 at 02:08:42PM -0500, Scott Wood wrote:
>>> Russell King wrote:
>>>> No one has brought that up on the ARM mailing lists - so does this issue
>>>> really exist?  All of the stuff I see on the ARM lists seems to be well
>>>> behaved and following our existing model - even vendor stuff (supplied
>>>> to me under NDA) seems to generally get this kind of stuff right.
>>> I'm just going by what I've seen on the u-boot list lately.  What is 
>>> the  existing ARM Linux model for passing MAC addresses, so that we 
>>> can point  people to that when they try to get u-boot to do silly 
>>> things?
>>
>> To program them into the hardware registers, 
>
> Isn't that adding a requirement to the boot firmware?  I thought you  
> didn't like that? :-)
>
> The patches that were proposed (and NACKed) in u-boot did exactly this  
> -- except supposedly they would only set the MAC address if the  
> interface were actually used prior to booting the kernel.
The patch proposed was only set the mac address in the register independtly
if you use the interface or not. But it will require that you enable the
interface driver.

Best Regards,
J.
