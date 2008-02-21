Return-Path: <linux-kernel-owner+w=401wt.eu-S935129AbYBUWdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935129AbYBUWdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934361AbYBUWdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:33:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54296 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934216AbYBUWd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:33:29 -0500
Message-ID: <47BDFC26.8000201@garzik.org>
Date: Thu, 21 Feb 2008 17:33:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>	<20080221154951.GA28328@cs181133002.pp.htv.fi>	<adahcg2awag.fsf@cisco.com>	<20080221210124.GD28328@cs181133002.pp.htv.fi> <20080221140855.6aea8cc1@laptopd505.fenrus.org>
In-Reply-To: <20080221140855.6aea8cc1@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 21 Feb 2008 23:01:24 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
>> [ Linus Added to the To: since I want to hear his opinion on this
>> issue. ]
>>
>> On Thu, Feb 21, 2008 at 12:28:55PM -0800, Roland Dreier wrote:
>>>  > This driver should really have gotten some review before being
>>>  > included in the kernel.
>>>
>>>  > Even a simple checkpatch run finds more than > 250 stylistic
>>>  > errors (not code bugs but cases where the driver violates the
>>>  > standard code formatting rules of kernel code).
>>>
>>> Linus has strongly stated that we should merge hardware drivers
>>> early, and I agree: although the nes driver clearly needs more
>>> work, there's no advantage to users with the hardware in forcing
>>> them to wait for 2.6.26 to merge the driver, since they'll just
>>> have to patch the grungy code in themselves anyway.  And by merging
>>> the driver early, we get fixed up for any tree-wide changes and
>>> allow janitors to help with the cleanup.
>> Is it really intended to merge drivers without _any_ kind of review?
> 
> No of course not.
> 
> I totally agree we should be more agressive in merging drivers earlier.
> A minimal review needs to happen so for a few things imo
> 1) That the driver doesn't break the build
> 2) That the driver has no obvious huge security holes
>    (this is a big deal for unsuspecting users)
> 3) that there's not an obscene amount of "uses deprecated api" compiler warnings
>    (since those are annoying for everyone else)
> 4) that people who don't have the hardware are not negatively affected
>    (say crashes without the hw or so)

FWIW, my general guidelines for merging drivers in my areas are:

1) it's not fugly

2) it has an active maintainer who responds to feedback


I tend to think it is NOT in the best interests of Linux users, for us 
to merge vendor-fugly drivers with many layers of OS wrappers and 
similar obfuscation.

But similarly...  I merge drivers long before our SCSI maintainer will, 
and I value "it works" above stupid checkpatch warnings.

	Jeff



