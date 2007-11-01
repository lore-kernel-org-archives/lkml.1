Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbXKAVMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbXKAVMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXKAVMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:12:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52519 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbXKAVMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:12:30 -0400
Date: Thu, 1 Nov 2007 22:14:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFC] x86: unify Kconfig files
Message-ID: <20071101211406.GA7891@uranus.ravnborg.org>
References: <20071031215501.GA28556@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031215501.GA28556@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 10:55:01PM +0100, Sam Ravnborg wrote:
> It has been requested that we should let x86 behave like
> other architectures so we at config time decide for 32 or 64 bit.
> The challenge here is to mere the Kconfig files and I have done
> an attempt to do so.

Just a heads up...
I have started to redo the patch below in smaller chunks and expect
to finish this tomorrow.
The cpufreq Kconfig file is done so no need for help here.

I hope to make the patches small enough so we can be confident to
apply them despite that we are heading -rc2.
It would be nice to get "make ARCH=x86" working before next
kernel release - and with the Kconfig files merged this is trivial.
I hope the x86 maintainers agree - but that yours decision.

	Sam
