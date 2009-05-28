Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbZE1D3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbZE1D3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZE1D3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:29:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:44021 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbZE1D3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <20090528000707.GR6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> 
	<20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> 
	<20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> 
	<20090528000707.GR6805@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 21:29:26 -0600
Message-ID: <fa686aa40905272029n32aa5f1ds86d07f0de4894815@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 6:07 PM, Robert Schwebel
<r.schwebel@pengutronix.de> wrote:
> On Wed, May 27, 2009 at 06:58:24PM -0500, Scott Wood wrote:
>> Robert Schwebel wrote:
>>> The oftree by design wants to be a complete hardware description. As
>>> you mention above, there are cases where you *nevertheless* need
>>> ad-hoc information about things *not* encoded into the device tree.
>>>
>>> This renders the whole concept ad absurdum. You need a machine number
>>> again - and if you need that: why not stay with the ARM model, define
>>> everything with platform data and avoid the whole thing?
>>
>> Because it's better to have a little platform specific code than a lot
>> of it?
>
> Until now, oftree has created more problems than it has solved for us.
> The idea works fine for well-known things like memory maps and
> interrupts. It works badly for corner cases, and embedded land is full
> of it. The effort to get the oftree stuff right is often more than a
> magnitude of order higher than the effort for the actual functionality.
> That should be an alarm sign that something is wrong.

Personally, I attribute a lot of that in powerpc land to the fact that
we had no clue what we were doing when we started the process of
porting all powerpc platforms to use the device tree.  It was hard.
It was painful.  We didn't have much established convention to learn
from.  However, now that it is complete I would say that it has been a
net-win and it is now simpler to bring up new boards and SoCs than it
ever was before.

Now we do know what we are doing and it should never cause that level
of pain again.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
