Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZEMIAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZEMIAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZEMIAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:00:39 -0400
Received: from rrzmta2.rz.uni-regensburg.de ([194.94.155.53]:8310 "EHLO
	rrzmta2.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbZEMIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:00:39 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaetsklinikum Regensburg
To: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 13 May 2009 09:59:59 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
CC: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
Message-ID: <4A0A9A23.24720.54D53C4@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain>
References: <1242094321.7214.156.camel@localhost.localdomain>, <1242167171.3462.13.camel@localhost>, <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.29/Sophos-P=4.41.0+V=4.41+U=2.07.230+R=04 May 2009+T=728364@20090513.080027Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2009 at 0:42, Thomas Gleixner wrote:

[...]
> I'm fine with the command line option, but I refuse to add some sys/
> thingy which makes us add extra calibration stuff.
> 
> Honestly all this is just the futile attempt to fix the flaws of NTP
> via (super)user interaction.

This has nothing to do with flaws in NTP (AFAIK).

> 
> Darn, it can not be that hard to adjust the math to do what you think
> it should do. I'm not an expert on that NTP stuff, but blindly
> stuffing the last known value into the kernel and expect that the
> calibration value did not change is nonsense.

Well, the assumption most likely is that if the hardware didn't change, kernel's 
calibration results also shouldn't change.

> 
> You know the calibration value which created the last known parameters
> and you want an extra interface to inject this last known calibration
> value into the kernel instead of doing the math of adjusting the NTP
> parameters according to the change of calibration values ?

I think, the wole issue is somewhat "cosmetics of statistics": People don't want 
to see a "clock frequency hops" after rebooting the machine (and restarting NTP). 
Usually there are thermal effects anyway, so what... Maybe it's just about "making 
everything perfect". For most people it's "good enough" already probably.

Regards,
Ulrich



> 
> Thanks,
> 
> 	tglx
> 
> 


