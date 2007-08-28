Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbXH1RYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbXH1RYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759707AbXH1RXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:23:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55222 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597AbXH1RXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:23:17 -0400
Message-ID: <46D45A02.6010306@zytor.com>
Date: Tue, 28 Aug 2007 10:23:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ok to kill "ether=" kernel parm?
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain> <46D45111.2040600@zytor.com> <Pine.LNX.4.64.0708281300030.18151@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708281300030.18151@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Tue, 28 Aug 2007, H. Peter Anvin wrote:
> 
>> Robert P. J. Day wrote:
>>>   given that "ether=" has been officially obsolete since 2.6.18
>>> (replaced by "netdev="), is there any reason to keep it around?
>>> or can it be blasted?
>> That sounds like way too short of a timeline for breaking people's
>> working boot setup.  For a lot of people, 2.6.18->current is going
>> to be a single step.
> 
> actually, now that i look more closely at the code browser at
> lxr.linux.no, "ether=" has been listed as "obsolete" since *at least*
> 2.6.10.  not to sound unsympathetic but anyone who tries to jump from
> 2.6.10 to 2.6.24 in one step deserves what they get.  :-)
> 
> ok, that was cruel, but you see my point, right?

Yes, and I think it's quite pointless.

The thing is, people's boot setups have probably been that way since
*long* before 2.6.9.  They continue to work, as they should, so they
aren't changed.  This is why we very rarely break boot interfaces (and
this is a user-visible interface you're talking about); we're still
supporting interfaces that have been obsolete *SINCE BEFORE 1.0 WAS
RELEASED.*

What's the upside of changing?  What's the downside?  The upside is so
infinitesimal that that leaving "ether=" in indefinitely seems like a
good move to me.

	-hpa

