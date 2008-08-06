Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYHFWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYHFWTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYHFWTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:19:36 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4201 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYHFWTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:19:35 -0400
X-BigFish: VPS-33(zz1432R98dR1805M936fQzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <489A2419.2030900@am.sony.com>
Date: Wed, 6 Aug 2008 15:22:17 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
References: <489A1844.3090502@am.sony.com> <20080806220445.GB10168@pengutronix.de>
In-Reply-To: <20080806220445.GB10168@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2008 22:19:22.0388 (UTC) FILETIME=[7A3B8540:01C8F812]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> On Wed, Aug 06, 2008 at 02:31:48PM -0700, Tim Bird wrote:
>> Add support for a built-in command line for x86 architectures.
>> The Kconfig help gives the major rationale for this addition.
> 
> If this feature is desired on all architectures, shouldn't it go out of
> arch/?

Different arches handle their command lines differently, but
with some elbow grease (and some buy-in from the different
arch maintainers), we could try unifying the approach here.

One difficulty is that the other arches' command lines
are not currently "broken", so there's no real incentive
to change them.

The only thing novel thing I'm adding here is the addition of
the leading '!' to allow for an override.  This is needed
in some x86 cases I'm familiar with, but I've haven't seen
any cases where it would be useful for other arches.
(not to say they don't exist - I just haven't seen them.)
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

