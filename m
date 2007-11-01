Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbXKAVWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbXKAVWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXKAVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:21:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbXKAVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:21:53 -0400
Message-ID: <472A435A.5030508@zytor.com>
Date: Thu, 01 Nov 2007 14:21:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH/RFC] x86: unify Kconfig files
References: <20071031215501.GA28556@uranus.ravnborg.org> <20071101211406.GA7891@uranus.ravnborg.org>
In-Reply-To: <20071101211406.GA7891@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Oct 31, 2007 at 10:55:01PM +0100, Sam Ravnborg wrote:
>> It has been requested that we should let x86 behave like
>> other architectures so we at config time decide for 32 or 64 bit.
>> The challenge here is to mere the Kconfig files and I have done
>> an attempt to do so.
> 
> Just a heads up...
> I have started to redo the patch below in smaller chunks and expect
> to finish this tomorrow.
> The cpufreq Kconfig file is done so no need for help here.
> 
> I hope to make the patches small enough so we can be confident to
> apply them despite that we are heading -rc2.
> It would be nice to get "make ARCH=x86" working before next
> kernel release - and with the Kconfig files merged this is trivial.
> I hope the x86 maintainers agree - but that yours decision.
> 

I looked over your patch yesterday and it looked sane to me, but I would 
definitely prefer if it was broken up for reviewability.

	-hpa
