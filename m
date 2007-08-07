Return-Path: <linux-kernel-owner+w=401wt.eu-S934709AbXHGPIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbXHGPIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXHGPIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:08:34 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47357 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbXHGPId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:08:33 -0400
Date: Tue, 7 Aug 2007 17:08:26 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] sdio: disable CD resistor
Message-ID: <20070807170826.0c32801b@poseidon.drzeus.cx>
In-Reply-To: <46B885CC.6030404@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
	<46B86BDF.8050700@csr.com>
	<20070807154342.47f63cfe@poseidon.drzeus.cx>
	<46B885CC.6030404@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 15:46:36 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> 
> Is there an example driver for a host that uses pin 1/DAT3 sensing for
> card detection?  I'm curious about how removal detections work.
> 

Both wbsd and sdhci have experienced hardware with this. In sdhci this
is hidden completely in hardware, but wbsd has to do some funky logic
to handle the problem.

> App Note on card detection goes into the use of this resistor in more
> detail but I don't believe this document is publicly available :(.
> 

SD is a wonderful world. :/

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
