Return-Path: <linux-kernel-owner+w=401wt.eu-S1765190AbXHHKG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765190AbXHHKG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXHHKGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:06:18 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:55749 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbXHHKGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:06:17 -0400
Date: Wed, 8 Aug 2007 12:06:13 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] sdio: set the functions' block size
Message-ID: <20070808120613.6b88a0d4@poseidon.drzeus.cx>
In-Reply-To: <46B990F0.2020001@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
	<46B86B88.5050009@csr.com>
	<20070807153800.734a6cbf@poseidon.drzeus.cx>
	<46B8A9DA.9030804@csr.com>
	<20070807195445.62d107e2@poseidon.drzeus.cx>
	<46B990F0.2020001@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Aug 2007 10:46:24 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> Pierre Ossman wrote:
> > 
> >> A driver might enable/disable a function multiple
> >> times but there's no need to set the block size every time.
> > 
> > Why would it want to do that?
> 
> A function enable/disable cycle should act as a per-function reset.
> 

It could be argued that it would reset the other per-function
information as well. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
