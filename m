Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYHFXDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYHFXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 19:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYHFXDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 19:03:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYHFXDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 19:03:35 -0400
Message-ID: <489A2DCD.8020804@zytor.com>
Date: Wed, 06 Aug 2008 16:03:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
References: <489A1844.3090502@am.sony.com> <20080806220445.GB10168@pengutronix.de> <489A2419.2030900@am.sony.com> <489A2A24.6010400@zytor.com> <489A2D0F.2070102@am.sony.com>
In-Reply-To: <489A2D0F.2070102@am.sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> 
>> CONFIG_CMDLINE_OVERRIDE is probably more palatable to other architectures.
> 
> I'd be OK implementing it with an option, rather than a magic char.
> I was trying to avoid adding too many options, since many kernel
> developers prefer fewer options where possible.  But the magic
> char makes the code less straightforward.
> 
> If we ever move towards supporting both prefix and suffice splicing (or
> even complicated in-the-middle splicing), then the magic char is
> easier to develop into that.  But so far, I can only come up with
> reasonable cases for append and override, and I don't want to add
> superfluous handling for non-existent use cases.

I think I agree, and the override option would make it easier to make 
generic.

	-hpa

