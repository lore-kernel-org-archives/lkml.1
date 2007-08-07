Return-Path: <linux-kernel-owner+w=401wt.eu-S934788AbXHGNn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788AbXHGNn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933423AbXHGNnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:43:46 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44927 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485AbXHGNno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:43:44 -0400
Date: Tue, 7 Aug 2007 15:43:42 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] sdio: disable CD resistor
Message-ID: <20070807154342.47f63cfe@poseidon.drzeus.cx>
In-Reply-To: <46B86BDF.8050700@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
	<46B86BDF.8050700@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 13:55:59 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> sdio: disable CD resistor
> 
> Disable the card detect resistor to ensure all data lines are equally
> loaded. Not doing this can have a negative impact on buses with
> marginal signal quality.
> 
> Signed-off-by: David Vrabel <david.vrabel@csr.com>

I'm not sure about this. I've seen several hosts which lack a
mechanical detect switch.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
