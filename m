Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYHFW66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYHFW66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYHFW6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:58:46 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25440 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYHFW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:58:45 -0400
X-BigFish: VPS-24(zz1432R98dR1805Mzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <489A2D0F.2070102@am.sony.com>
Date: Wed, 6 Aug 2008 16:00:31 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
References: <489A1844.3090502@am.sony.com> <20080806220445.GB10168@pengutronix.de> <489A2419.2030900@am.sony.com> <489A2A24.6010400@zytor.com>
In-Reply-To: <489A2A24.6010400@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2008 22:57:36.0389 (UTC) FILETIME=[D1904B50:01C8F817]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Tim Bird wrote:
>> The only thing novel thing I'm adding here is the addition of
>> the leading '!' to allow for an override.  This is needed
>> in some x86 cases I'm familiar with, but I've haven't seen
>> any cases where it would be useful for other arches.
>> (not to say they don't exist - I just haven't seen them.)
>>
> 
> Note that it could just as easily be done with a CONFIG_CMDLINE_OVERRIDE
> option, since the initial reason for a magic character was to be able to
> provide both prefix and suffix splicing.
Agreed.

> 
> CONFIG_CMDLINE_OVERRIDE is probably more palatable to other architectures.

I'd be OK implementing it with an option, rather than a magic char.
I was trying to avoid adding too many options, since many kernel
developers prefer fewer options where possible.  But the magic
char makes the code less straightforward.

If we ever move towards supporting both prefix and suffice splicing (or
even complicated in-the-middle splicing), then the magic char is
easier to develop into that.  But so far, I can only come up with
reasonable cases for append and override, and I don't want to add
superfluous handling for non-existent use cases.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

