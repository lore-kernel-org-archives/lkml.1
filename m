Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZD2Xkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZD2Xkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZD2XkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:40:22 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:48833 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZD2XkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:40:21 -0400
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2009 19:40:20 EDT
Date: Wed, 29 Apr 2009 18:25:23 -0500
From: David Fries <david@fries.net>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: TSC marked unstable on suspend and resume
Message-ID: <20090429232523.GO2862@spacedout.fries.net>
References: <20090221023943.GA4894@spacedout.fries.net> <1f1b08da0904290945j79e1b578ye415fe4ced259b15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1f1b08da0904290945j79e1b578ye415fe4ced259b15@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 29 Apr 2009 18:25:27 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 29, 2009 at 09:45:40AM -0700, john stultz wrote:
> On Fri, Feb 20, 2009 at 7:39 PM, David Fries <david@fries.net> wrote:
> > I'm getting TSC marked as unsable on hibernate to disk with
> > 2.6.29-rc3. ?The last kernel I ran 2.6.24.4 ran 300+ days without a
> > problem and does not loose TSC on hibernate.
> >
> > I'm hibernating with `echo disk > /sys/power/state`.
> > These look like the relavant messages,
> >
> > CPU 0 irqstacks, hard=c0379000 soft=c0378000
> > PID hash table entries: 1024 (order: 10, 4096 bytes)
> > Fast TSC calibration using PIT
> > Detected 300.705 MHz processor.
> > Calibrating delay loop (skipped), value calculated using timer frequency.. 601.41 BogoMIPS (lpj=300705)
> > hibernate to disk,
> > Restarting tasks ... done.
> > Clocksource tsc unstable (delta = 499883531 ns)
> 
> Hmm. Seems like the clocksource watchdog is having some problem
> handling state around hibernate.
> 
> Out of curiousity: Does suspend-to-ram also trigger this?

Suspend to ram isn't supported by the system, disk is the only
available /sys/power/state.

> Can you send me a full dmesg log?

Attached, it was the only log I saw that had bootup through the tsc
marked unstable.  Looking at the log I assume I booted to a shell,
hibernated, resumed, then ran init, in that case the system is as
fresh and idle as it gets.  This system's been up for two months and I
don't reboot much so I don't remember for sure.

> thanks
> -john

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

--KsGdsel6WgEHnImy
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="dmesg.3.gz"
Content-Transfer-Encoding: base64

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
zTl1l7bxDtzTmFkSPAAA

--KsGdsel6WgEHnImy--
