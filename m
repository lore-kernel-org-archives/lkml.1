Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbZAWNEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbZAWNEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZAWNEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:04:31 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:6738 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZAWNEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:04:30 -0500
X-BigFish: VPS-41(zz1432R98dR936eQ4015M1805M936fMzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KDXDN3-02-AL7-01
Date: Fri, 23 Jan 2009 14:04:16 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: markh@compro.net, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Petkov, Borislav" <borislav.petkov@amd.com>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
	processor
Message-ID: <20090123130416.GA27616@alberich.amd.com>
References: <497322CC.7050900@cfl.rr.com> <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com> <49759499.4050708@cfl.rr.com> <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <49798F33.8070906@cfl.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 23 Jan 2009 13:04:17.0889 (UTC) FILETIME=[196DC510:01C97D5B]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 10:34:43AM +0100, Mark Hounschell wrote:
> Mark Hounschell wrote:
> > The MB is a Biostar TA770+. It is not yet listed as one with new
> > BIOS support for the Phenom-II. Only the TA770+ SE is at the moment.
> > The only difference in the Sata port arrangement and the BIOS type.
> > 
> > I guess I'll just keep pinging them.
> 
> OK I have now the official bios for this CPU/MB combo. I still cannot boot a
> 1000 HZ kernel.

Looking at the Biostar pages I am still not completely convinced that
your CPU/MB combo is supported. At least it is not listed there.
So far TA770 A2+ SE, rev. 6.X, is listed. Did the Biostar folks confirm you
that your mobo model/revision is supported, too?

>  Here is my new dmesg while running a 250Hz kernel.

...

> Linux version 2.6.26.8 (root@harley) (gcc version 4.3.1 20080507 (prerelease)
...
> CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
...
> CPU1: AMD Phenom(tm) II X4 940 Processor stepping 02
...
> CPU2: AMD Phenom(tm) II X4 940 Processor stepping 02
...
> CPU3: AMD Phenom(tm) II X4 940 Processor stepping 02

Looks good so far.

> eth0: no IPv6 routers present
> warning: `ntpd' uses deprecated v2 capabilities in a way that may be insecure.
> hda-intel: Invalid position buffer, using LPIB read method instead.
> NET: Registered protocol family 4
> NET: Registered protocol family 3
> NET: Registered protocol family 5

This reminds me of some system hangs with older kernels when C1E was
activated.

Can you please try to boot with idle=poll, or idle=mwait, or nolapic_timer
when using 2.6.26.X?
Can you also try to boot .27 or .28?


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


