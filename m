Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbXFLUKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbXFLUKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 16:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbXFLUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 16:09:55 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1108 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXFLUJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 16:09:54 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: PC speaker
Date: Tue, 12 Jun 2007 13:08:53 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070612161951.69e54751@the-village.bc.nu>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 12 Jun 2007 13:09:23 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 12 Jun 2007 13:09:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > >I'd say impossible. Just disconnect it from the motherboard.
> >
> > The days when hardware *relied* on software (hence, where software
> > could damage hardware) are over.

> Nice theory but you can destroy or render useless a fair amount of PC
> hardware via software, usually because the thing is *DESIGNED* that way
> for convenience. (Flash update interfaces without jumpers, locking
> interfaces for drives etc)

Other great examples are hardware that allows you to control voltages, fan
speeds, and operating frequencies. Sometimes you can overvoltage it directly
and blow it immediately. Other times, you can increase the voltage and
operating frequency and decrease the fan speed to the point where it stops
spinning. This is possible on many modern graphics cards and CPUs.

As far as burning out a speaker goes, if you can drop the frequency to zero
(DC) and get continuous current through the speaker, that could burn it out.
This makes several assumptions, many of which may not be true on modern PCs:

1) It assumes the speaker is a conventional coil speaker, not a piezo
element. (This is certainly true on some PCs, although it's increasingly
false on newer PCs.)

2) It assumes the speaker is DC driven. (I'm pretty sure this was true on
the original IBM PC. Not sure about newer computers.)

3) It assumes you can configure the circuitry that drives the speaker such
that it will stay on. (No idea.)

4) It assumes the current will be sufficient to burn out the speaker. (I
know it will get very hot on older machines, whether it will burn out --
might even depend on the exact speaker model.)

On at least some older computers, you could burn out the hardware that drove
the speaker this way. I think it was either the Pet or the Apple ][ (didn't
work on all machines, depended on how much current the speaker drew and
other odd factors). I witnessed an Apple ][e blow out an I/O chip when it
crashed with an output (that was supposed to be pulsed) left in the on
position.

DS


