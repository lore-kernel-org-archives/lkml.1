Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZDUTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZDUTMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZDUTM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:12:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37765 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbZDUTM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:12:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Booting 2.6.30-rc2-git7 very slow
Date: Tue, 21 Apr 2009 21:12:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <547506.26789.qm@web32603.mail.mud.yahoo.com>
In-Reply-To: <547506.26789.qm@web32603.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904212112.20278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009, Martin Knoblauch wrote:
> 
> Hi, [please CC me on replies, as I am not subscribed]
> 
>  booting  2.6.30-rc2-git7 on a HP/DL380G3 (x86_64, RHEL4.3, 64 bit userspace) is much slower that it used to be. It seems I run into timeouts when [trying to] load intel and tg3 microcodes:
> 
> [   14.478892] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [   74.476741] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [  134.476638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [  194.476637] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [  254.476493] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [  254.718489] Microcode Update Driver: v2.00 removed.
> 
>  So, we see 60 seconds for eaoch of the CPUs
> 
> [  255.273426] tg3 0000:03:01.0: PME# disabled
> [  257.833769] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> [  257.833775] tg3: eth0: Flow control is off for TX and off for RX.
> [  269.643973] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> [  329.640456] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> [  329.640463] eth1: TSO capability disabled.
> [  329.640487] tg3 0000:03:01.1: PME# disabled
> [  333.081753] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> [  333.081759] tg3: eth1: Flow control is off for TX and off for RX.
> 
>  We see 60 seconds for eth1, complaining about a failed firmware load.
> /lib/firmware/tigon/tg3_tso.bin does exist and is from the current
> build.

Do I assume correctly that 2.6.29 did not have this problem?

Rafael
