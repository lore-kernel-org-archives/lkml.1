Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbYDNIgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbYDNIgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbYDNIgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:36:00 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:41971 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876AbYDNIf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:35:59 -0400
Date: Mon, 14 Apr 2008 10:35:04 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: benh@kernel.crashing.org
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080414103504.24025b44@mjolnir.drzeus.cx>
In-Reply-To: <1208122634.6958.59.camel@pasglop>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	<20080404210132.GA14418@suse.de>
	<20080405115727.1265e8a9@mjolnir.drzeus.cx>
	<20080405155323.GA27252@suse.de>
	<20080405185501.41ec42a7@mjolnir.drzeus.cx>
	<1208122634.6958.59.camel@pasglop>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 07:37:14 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> You don't need a timer. You can just use the notifier mechanism I added
> a while ago that should call you on device addition and removal on the
> bus type you are interested in.
> 

Another solution presented itself, but do you have some pointers on
where I get more information about the notifiers in case I need them
in the future?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
