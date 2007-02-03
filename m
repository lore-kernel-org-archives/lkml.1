Return-Path: <linux-kernel-owner+w=401wt.eu-S1946460AbXBCO1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946460AbXBCO1D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 09:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946462AbXBCO1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 09:27:03 -0500
Received: from oola.is.scarlet.be ([193.74.71.23]:49719 "EHLO
	oola.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946460AbXBCO1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 09:27:01 -0500
Message-ID: <45C49A88.4050809@joow.be>
Date: Sat, 03 Feb 2007 15:22:00 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Dennedy <dan@dennedy.org>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] ieee1394: cycle timer read extension for	raw1394/libraw1394
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de>	<45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de> <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
In-Reply-To: <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: oola 20001; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> From: Pieter Palmers <pieterp@joow.be>
> 
> This implements the simultaneous read of the isochronous cycle timer and
> the system clock (in usecs).  This allows to express the exact receive
> time of an ISO packet as a system time with microsecond accuracy.
> http://bugzilla.kernel.org/show_bug.cgi?id=7773
> 
> The counterpart patch for libraw1394 can be found at
> http://thread.gmane.org/gmane.linux.kernel.firewire.devel/8934
> 
> Patch update (Stefan R.):
>   - Disable preemption and local interrupts.
>   - Fix integer overflow.
I had to use 1000000ULL instead of USEC_PER_SEC to avoid weird behavior.

>   - Add paranoid error checks and kerneldoc to hpsb_read_cycle_timer.
>     Move it to other ieee1394_core high-level API functions.
>   - Rename userspace-exported struct _raw1394_cycle_timer to
>     raw1394_cycle_timer.  Change comments in raw1394.
>   - Adjust whitespace.
Thanks for the cleanups!

I can't test it right now, but I'll report later.

Pieter
