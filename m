Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZD3XRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZD3XRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZD3XRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:17:46 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:46662 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZD3XRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NO2Wrs2jQqmBCTgoHKit3M6T2W/jB5teJh6W5USh4/yD2vQ5UgAw9DjEDDtL79d3OD
         A46tkdJQjZouBQdZh1xGuAa2iOn5KoMOGGptZuCbiuzk72fD/Z7NKzfWGPjSCpvzhbbs
         FaP9huR7lKGMpKiG3ascUpAOgIHMwJJAi8aEE=
MIME-Version: 1.0
In-Reply-To: <72dbd3150904241845q5ed1fe15ob4fa2ba06e96ea72@mail.gmail.com>
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi> <20090310101807.GD20716@alberich.amd.com> 
	<20090311100525.GE20716@alberich.amd.com> <49B7A79A.6090008@msgid.tls.msk.ru> 
	<87ocw8qfwg.fsf@divinity.mikat.iki.fi> <49C919B9.70302@msgid.tls.msk.ru> 
	<72dbd3150904241845q5ed1fe15ob4fa2ba06e96ea72@mail.gmail.com>
From: David Rees <drees76@gmail.com>
Date: Thu, 30 Apr 2009 16:17:23 -0700
Message-ID: <72dbd3150904301617i1fb69083u301162bbcd4bf5b6@mail.gmail.com>
Subject: Re: Slow clock on AMD 740G chipset
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Mika Tiainen <mikat@iki.fi>, Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 6:45 PM, David Rees <drees76@gmail.com> wrote:
> On Tue, Mar 24, 2009 at 10:34 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> To refresh what has been said.  Several people observed slow clock
>> on their - mostly AMD 780g, 740g and 690g-based systems with 2.6.28
>> 2.6.27 kernels.  Slow to a point when ntpd wasn't successful to
>> keep up with the drift.  It has been said that the motherboards are
>> flaky or something and that the clocks has to be calibrated, for
>> which there are known procedures available (adjtimex).  Which helped.
>> Before the "calibration" the clock were off by ~15 minutes per day.
>
> This is really weird.  I earlier posted to the thread saying things
> were fine on a Fedora 10 2.6.27.9-159.fc10.x86_64 kernel.
>
> Then mysteriously after a machine reboot to install new hardware[1] on
> March 27th on kernel 2.6.27.19-170.2.35.fc10.x86_64 (previous running
> kernel was the same), the clock started running slow to the tune of
> ntpd resetting the time every 15-18 minutes forward about 2.3 seconds.
>
> Fast forward to today (now running 2.6.29.1-30.fc10.x86_64) and the
> clock is still running slow.
>
> I don't know - my system (GA-MA74GM-S2 mobo) is still broken.
>
> [1] So the hardware I installed was a SATA SSD (OCZ Vertex). Ever
> since then, the clock has been running fast.  Previously, the only
> thing on the SATA bus was a DVD drive - it has two IDE drives, one
> plugged in on board and the other into a Promise IDE card.
>
> When doing so, the sata ports are now running in AHCI mode instead of
> native mode.  I'll have to try switching later.

Another update.  Two nights ago I set the SATA ports in IDE mode to
try to flash the OCZ Vertex to the latest firmware 1370, previously
running 1275 (The flash failed as the flashing utility could not
detect the drives in the system).  Clock still ran slow.  Last night,
I succeeded in flashing the drive after putting it in another system.

Since then, the clock has been keeping time very well - at least it's
not losing 2-3 seconds every 15 minutes.

So is it possible for a SATA drive to somehow affect the speed of the clock?

-Dave
