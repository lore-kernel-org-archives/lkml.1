Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYBYRM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYBYRM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYBYRMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:12:49 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55302 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYBYRMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:12:48 -0500
Date: Mon, 25 Feb 2008 18:12:14 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MMC core debugfs support (was Re: [RFC v2 5/5] Atmel MCI:
 Driver for Atmel on-chip MMC controllers)
Message-ID: <20080225181214.0860f622@mjolnir.drzeus.cx>
In-Reply-To: <20080214150005.2c46a991@dhcp-252-066.norway.atmel.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	<20080213193051.1a7e3b29@poseidon.drzeus.cx>
	<20080214150005.2c46a991@dhcp-252-066.norway.atmel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 15:00:05 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> 
> I've started working on this, but I've run into a problem: The mmc core
> structures don't seem to keep any references to the current request. So
> I don't really have any information to put into the 'req' file after
> moving it into the core.
> 
> Any ideas on how to solve this?
> 

The simple solution is just to add it. :)

But is it needed though? Shouldn't a read block until there is an event, at which point you'll have access to the data structures long enough to output data.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
