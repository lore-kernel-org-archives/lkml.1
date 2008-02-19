Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYBSTvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYBSTvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYBSTv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:51:26 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:56685 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYBSTvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:51:25 -0500
Date: Tue, 19 Feb 2008 21:51:19 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: random wedges with 2.6.25-rc*
Message-ID: <20080219215119.25c5e933@mjolnir.drzeus.cx>
In-Reply-To: <47BB1801.1000008@garzik.org>
References: <20080219191035.252d5787@mjolnir.drzeus.cx>
	<47BB1801.1000008@garzik.org>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 12:55:13 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Pierre Ossman wrote:
> > 
> > Anyone else seeing these problems? Someone should as I've seen the problem on both a Lenovo and a HP laptop here.
> 
> 
> I'm definitely seeing lockups here too.  2.6.24 is fine, 2.6.24-rc1 or 
> -rc2 locks up a minute or so after a successful boot (either to console 
> or to X).
> 
> Does the following shed any light?
> 
> http://lkml.org/lkml/2008/2/17/78
> 

That would explain the lockups in X as the network has been active at those times. But it would be odd if it affects the startup of udev (most likely module loading).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
