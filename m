Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbYHFWsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbYHFWsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYHFWsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:48:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYHFWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:48:00 -0400
Message-ID: <489A2A24.6010400@zytor.com>
Date: Wed, 06 Aug 2008 15:48:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
References: <489A1844.3090502@am.sony.com> <20080806220445.GB10168@pengutronix.de> <489A2419.2030900@am.sony.com>
In-Reply-To: <489A2419.2030900@am.sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> 
> One difficulty is that the other arches' command lines
> are not currently "broken", so there's no real incentive
> to change them.
> 
> The only thing novel thing I'm adding here is the addition of
> the leading '!' to allow for an override.  This is needed
> in some x86 cases I'm familiar with, but I've haven't seen
> any cases where it would be useful for other arches.
> (not to say they don't exist - I just haven't seen them.)
> 

Note that it could just as easily be done with a CONFIG_CMDLINE_OVERRIDE 
option, since the initial reason for a magic character was to be able to 
provide both prefix and suffix splicing.

CONFIG_CMDLINE_OVERRIDE is probably more palatable to other architectures.

	-hpa
