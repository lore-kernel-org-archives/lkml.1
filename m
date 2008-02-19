Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYBSRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYBSRKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYBSRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:10:40 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:38659 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbYBSRKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:10:40 -0500
Date: Tue, 19 Feb 2008 19:10:35 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>
Subject: random wedges with 2.6.25-rc*
Message-ID: <20080219191035.252d5787@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere post 2.6.24, the kernel started getting very temperamentful. I experience random hangs and wedges very often.

Primarily, the udev startup locks up. If I abort it, it just locks up on more or less every action after that. Some quick debugging showed that I had a whole bunch of modprobe processes sitting around. The new CONFIG_USB_ANNOUNCE_NEW_DEVICES setting makes every startup of udev lock up consistently on at least two machines. It does not seem to be the root of the problem as disabling the option just makes the bug very unlikely.

I've also seen a couple of lockups in X. Might be a different expression of the same bug, but the effect here is a complete wedge of the user interface. It seems the rest of the machine also locks up, but I haven't confirmed this.

Anyone else seeing these problems? Someone should as I've seen the problem on both a Lenovo and a HP laptop here.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
