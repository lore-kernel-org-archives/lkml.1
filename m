Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXLARsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXLARsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 12:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXLARr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 12:47:56 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:34492 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbXLARr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 12:47:56 -0500
Date: Sat, 1 Dec 2007 18:47:52 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jakub@redhat.com
Subject: Re: Fedora's latest gcc produces unbootable kernels
Message-ID: <20071201184752.33536d09@poseidon.drzeus.cx>
In-Reply-To: <20071201154223.1b052d39@poseidon.drzeus.cx>
References: <20071201154223.1b052d39@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 15:42:23 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> The latest GCC in Fedora rawhide contains some serious bug (or provokes a latent one in the kernel) that makes every kernel built unbootable. It just locks up halfway through the init. Kernels that previously worked fine all now experience the same symptom. Even RH's own kernels exhibit this. The kernel built Nov 24th works, Nov 26th doesn't. gcc was updated 26th, 14 hours earlier.
> 

Digging a bit further, it is indeed the high-res stuff (the first missing message) that hangs. If I hard code the kernel to just be non-high-res capable, it boots, but time keeping is horribly broken.

Anyway, hopefully this means I'll soon have the object file that gets miscompiled. Jakub also pointed me to an older gcc RPM so that I can produce an object file with that as well and see what differs.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
