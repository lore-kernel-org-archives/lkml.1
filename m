Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZDTTaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZDTTaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZDTT3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:29:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbZDTT3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:29:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: 2.6.29 regression: left audio channel broken after resume from suspend with Intel HDA
Date: Mon, 20 Apr 2009 21:28:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, tiwai@suse.de
References: <20090420184024.GA10155@dose.home.local>
In-Reply-To: <20090420184024.GA10155@dose.home.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202129.00316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 April 2009, Tino Keitel wrote:
> Hi,
> 
> since 2.6.29 and also with 2.6.29.1 the left audio channel of the
> digital output of my Mac mini Core 2 Duo is noisy.  This didn't happen
> with 2.6.28.  Unloading snd-hda-intel and reloading it does fix the
> noisy sound.
> 
> This happened with some older versions of the Linux kernel (with an
> older Mac mini Core Duo, I don't remeber which kernel version), but got
> fixed at some point.  Now it happens again with 2.6.29.
> 
> Here is the dmesg output for the sound hardware:
> 
> HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> HDA Intel 0000:00:1b.0: setting latency timer to 64
> hda_codec: STAC922x, Apple subsys_id=100
> input: HDA Intel Line In at Ext Left Jack as /class/input/input18
> input: HDA Intel Mic at Ext Left Jack as /class/input/input19
> input: HDA Intel HP Out at Ext Left Jack as /class/input/input20
> 
> Any hints what I could try to fix this, maybe some commit that I should
> try to revert?

Well, no.

Still, you might try the current Linus' tree.

Best,
Rafael
