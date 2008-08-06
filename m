Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYHFWyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYHFWyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYHFWyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:54:11 -0400
Received: from waste.org ([66.93.16.53]:43015 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbYHFWyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:54:09 -0400
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <489A2A24.6010400@zytor.com>
References: <489A1844.3090502@am.sony.com>
	 <20080806220445.GB10168@pengutronix.de> <489A2419.2030900@am.sony.com>
	 <489A2A24.6010400@zytor.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 17:52:13 -0500
Message-Id: <1218063133.7576.16.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-08-06 at 15:48 -0700, H. Peter Anvin wrote:
> Tim Bird wrote:
> > 
> > One difficulty is that the other arches' command lines
> > are not currently "broken", so there's no real incentive
> > to change them.
> > 
> > The only thing novel thing I'm adding here is the addition of
> > the leading '!' to allow for an override.  This is needed
> > in some x86 cases I'm familiar with, but I've haven't seen
> > any cases where it would be useful for other arches.
> > (not to say they don't exist - I just haven't seen them.)
> > 
> 
> Note that it could just as easily be done with a CONFIG_CMDLINE_OVERRIDE 
> option, since the initial reason for a magic character was to be able to 
> provide both prefix and suffix splicing.

You're right, I had forgotten about the suffix splicing and my brain is
a bit foggy on what motivated it.

> CONFIG_CMDLINE_OVERRIDE is probably more palatable to other architectures.

Yes, though I doubt we're in danger of introducing any real backwards
compatibility issues with the magic '!' at the beginning.

-- 
Mathematics is the supreme nostalgia of our time.

