Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXLAOml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXLAOml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 09:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXLAOm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 09:42:28 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55993 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbXLAOm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 09:42:28 -0500
Date: Sat, 1 Dec 2007 15:42:23 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fedora's latest gcc produces unbootable kernels
Message-ID: <20071201154223.1b052d39@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest GCC in Fedora rawhide contains some serious bug (or provokes a latent one in the kernel) that makes every kernel built unbootable. It just locks up halfway through the init. Kernels that previously worked fine all now experience the same symptom. Even RH's own kernels exhibit this. The kernel built Nov 24th works, Nov 26th doesn't. gcc was updated 26th, 14 hours earlier.

The last message printed is:

isapnp: Scanning for PnP cards...

Comparing with the working kernel, the next steps are:

isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found

Any ideas on how I can work around this? I'm rather unproductive when I can't build working kernels.. :/

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
