Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYAHUt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYAHUt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYAHUtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:49:53 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:46170 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYAHUtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:49:52 -0500
Date: Tue, 8 Jan 2008 21:49:46 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080108214946.03018d95@poseidon.drzeus.cx>
In-Reply-To: <200801081440.49683.vapier.adi@gmail.com>
References: <200801081329.39611.vapier.adi@gmail.com>
	<20080108202157.0b8d3393@poseidon.drzeus.cx>
	<200801081440.49683.vapier.adi@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 14:40:49 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> 
> i dont understand what's confusing.  the Blackfin on chip host controller only 
> supports 1-bit MMC, but it supports 4-bit SD/SDIO.  this is a fact.  while it 
> may be a stupid decision, it is what it is, and i need the framework made 
> more flexible in order to get the Blackfin driver merged cleanly.  we do 
> software for hardware, we dont do hardware.

Well, since I've seen no _hardware_ differences between 4-bit MMC and 4-bit SD, "support" in this case must me "vendor will guarantee it works". And that is not the kind of "support" that needs a distinction in the code.

So, again, if you feel that there is a hardware difference between 4-bit MMC and 4-bit SD then please elaborate as it is my understanding that they are identical.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
